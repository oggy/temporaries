module Temporaries
  module Adapters
    class MiniTestSpec < Base
      def self.install
        MiniTest::Spec.class_eval do
          extend Extension
          include Values
          include Directory
        end
      end

      def before(&block)
        context.before(&block)
      end

      def after(&block)
        context.after(&block)
      end

      module Extension
        def temporaries_adapter
          MiniTestSpec.new(self)
        end
      end
    end
  end
end
