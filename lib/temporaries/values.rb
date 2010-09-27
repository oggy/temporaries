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

    class Helpers
      def initialize(name)
        @name = name
      end
      attr_reader :name

      [:signature, :get, :set].each do |name|
        attr_reader name
        class_eval <<-EOS
          def #{name}(source=nil)
            if source
              @#{name} = source
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
        mod.class_eval <<-EOS, __FILE__, __LINE__ + 1
          def push_#{name}_value(#{signature}, value)
            push_temporary(#{stack_key}, #{get})
            #{set}
          end

          def pop_#{name}_value(#{signature})
            value = pop_temporary(#{stack_key})
            #{set}
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
      end
    end

    def self.define_helpers_for(name, &block)
      helpers = Helpers.new(name)
      helpers.instance_eval(&block)
      helpers.define(self)
    end

    define_helpers_for :constant do
      signature 'mod, constant'
      get 'mod.const_get(constant)'
      set <<-EOS
        mod.instance_eval{remove_const(constant) if const_defined?(constant)
        const_set(constant, value)}
      EOS
    end

    define_helpers_for :attribute do
      signature 'object, attribute'
      get 'object.send(attribute)'
      set 'object.send("#{attribute}=", value)'
    end

    define_helpers_for :hash do
      signature 'hash, key'
      get 'hash[key]'
      set 'hash[key] = value'
    end

    define_helpers_for :instance_variable do
      signature 'object, name'
      get 'object.instance_variable_get("@#{name}")'
      set 'object.instance_variable_set("@#{name}", value)'
    end

    define_helpers_for :class_variable do
      signature 'klass, name'
      get 'klass.class_eval("@@#{name}")'
      set 'klass.class_eval("@@#{name} = value")'
    end

    define_helpers_for :global do
      signature 'name'
      get 'eval("$#{name}")'
      set 'eval("lambda{|value| $#{name} = value}").call(value)'
    end
  end
end
