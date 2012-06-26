module Temporaries
  module Adapters
    class TestUnit < Base
      def self.install(mod)
        mod::TestCase.class_eval do
          extend Extension
          include Values
          include Directory
        end
      end

      def before(&block)
        context.send(:include, self.module)
        context.befores << block
      end

      def after(&block)
        context.send(:include, self.module)
        context.afters << block
      end

      def module
        @module ||= Module.new do
          def self.included(base)
            base.extend self::ClassMethods
          end

          mod = Module.new do
            def befores
              @befores ||= []
            end

            def afters
              @afters ||= []
            end
          end
          const_set(:ClassMethods, mod)

          def setup
            self.class.befores.each{|proc| instance_eval(&proc)}
          end

          def teardown
            self.class.afters.each{|proc| instance_eval(&proc)}
          end
        end
      end

      module Extension
        def temporaries_adapter
          TestUnit.new(self)
        end
      end
    end
  end
end
