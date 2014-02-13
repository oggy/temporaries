module Temporaries
  module Adapters
    class MiniTest < Base
      def self.install
        ::MiniTest::Spec.class_eval do
          extend Extension
          include Values
          include Directory
        end
      end

      def before(&hook)
        context.__send__ :include, Module.new {
          define_method(:setup) do |*args, &block|
            super(*args, &block)
            instance_eval(&hook)
          end
        }
      end

      def after(&hook)
        context.__send__ :include, Module.new {
          define_method(:teardown) do |*args, &block|
            instance_eval(&hook)
            super(*args, &block)
          end
        }
      end

      module Extension
        def temporaries_adapter
          MiniTest.new(self)
        end
      end
    end
  end
end
