#
# Set temporary values for the duration of a block. These may be
# arbitrarily nested; the innermost definition applies.
#
#     with_hash_value hash, key, value do
#       ...
#     end
#
#     with_constant_value module, :constant, value do
#       ...
#     end
#
#     with_attribute_value object, :attribute, value do
#       ...
#     end
#
#     with_instance_variable_value object, :name, value do
#       ...
#     end
#
#     with_class_variable_value object, :name, value do
#       ...
#     end
#
#     with_global_value :name, value do
#       ...
#     end
#
# There are also the lower level:
#
#     push_hash_value hash, key, value
#     pop_hash_value hash, key
#
#     push_constant_value Module, :Constant, value
#     pop_constant_value Module, :Constant
#
#     push_attribute_value object, :attribute, value
#     pop_attribute_value object :attribute
#
#     push_instance_variable_value object, :name, value
#     pop_instance_variable_value object :name
#
#     push_class_variable_value klass, :name, value
#     pop_class_variable_value klass, :name
#
#     push_global_variable_value :name, value
#     pop_global_variable_value :name
#
module Temporaries
  module Values
    include Core

    UNDEFINED = RUBY_VERSION < '1.9' ? Object.new : BasicObject.new
    class << UNDEFINED
      def inspect
        '<UNDEFINED>'
      end
      alias to_s inspect
    end

    class Helpers
      def initialize(name)
        @name = name
      end
      attr_reader :name

      def signature(signature = nil)
        if signature
          @signature = signature
        else
          @signature
        end
      end

      [:exists, :get, :set, :remove].each do |name|
        attr_reader name
        class_eval <<-EOS
          def #{name}(source=nil)
            if source
              @#{name} = '(' + source + ')'
            else
              @#{name}
            end
          end
        EOS
      end

      def stack_key
        sig_ids = signature.split(/\s*,\s*/).map{|s| s + '.__id__'}.join(', ')
        "[:#{name}, #{sig_ids}]"
      end

      def define(mod)
        if exists
          save = "original_value = #{exists} ? #{get} : Temporaries::Values::UNDEFINED"
          restore = "value.equal?(Temporaries::Values::UNDEFINED) ? #{remove} : #{set}"
        else
          save = "original_value = #{get}"
          restore = set
        end

        mod.class_eval <<-EOS, __FILE__, __LINE__ + 1
          def push_#{name}_value(#{signature}, value)
            #{save}
            push_temporary(#{stack_key}, original_value)
            #{set}
          end

          def pop_#{name}_value(#{signature})
            value = pop_temporary(#{stack_key})
            #{restore}
          end

          def with_#{name}_value(#{signature}, value)
            push_#{name}_value(#{signature}, value)
            begin
              yield
            ensure
              pop_#{name}_value(#{signature})
            end
          end
        EOS

        mod::ClassMethods.module_eval <<-EOS, __FILE__, __LINE__ + 1
          def use_#{name}_value(#{signature}, value)
            temporaries_adapter.before do
              push_#{name}_value(#{signature}, value)
            end

            temporaries_adapter.after do
              pop_#{name}_value(#{signature})
            end
          end
        EOS
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
    end

    def self.define_helpers_for(name, &block)
      helpers = Helpers.new(name)
      helpers.instance_eval(&block)
      helpers.define(self)
    end

    define_helpers_for :constant do
      signature 'mod, constant'
      exists 'mod.const_defined?(constant)'
      get 'mod.const_get(constant)'
      set <<-EOS
        mod.instance_eval{remove_const(constant) if const_defined?(constant)
        const_set(constant, value)}
      EOS
      remove 'mod.send :remove_const, constant'
    end

    define_helpers_for :attribute do
      signature 'object, attribute'
      get 'object.send(attribute)'
      set 'object.send("#{attribute}=", value)'
    end

    define_helpers_for :hash do
      signature 'hash, key'
      exists 'hash.key?(key)'
      get 'hash[key]'
      set 'hash[key] = value'
      remove 'hash.delete(key)'
    end

    define_helpers_for :instance_variable do
      signature 'object, name'
      exists 'object.instance_variable_defined?("@#{name}")'
      get 'object.instance_variable_get "@#{name}"'
      set 'object.instance_variable_set "@#{name}", value'
      remove 'object.send :remove_instance_variable, "@#{name}"'
    end

    define_helpers_for :class_variable do
      signature 'klass, name'
      exists 'klass.class_variable_defined?("@@#{name}")'
      get 'klass.send :class_variable_get, "@@#{name}"'
      set 'klass.send :class_variable_set, "@@#{name}", value'
      remove 'klass.send :remove_class_variable, "@@#{name}"'
    end

    define_helpers_for :global do
      signature 'name'
      get 'eval("$#{name}")'
      set 'eval("$#{name} = value")'
    end
  end
end
