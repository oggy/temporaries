module Temporaries
  module Adapters
    class MiniTest < Base
      # For ruby <= 1.9.2, MiniTest is actually adapted via the
      # Test::Unit adapter.
      def self.install
        ::MiniTest::Unit::TestCase.class_eval do
          extend Extension
          include Values
          include Directory
        end
      end

      def before(&block)
        context.add_setup_hook {|tc| tc.instance_eval(&block) }
      end

      def after(&block)
        context.add_teardown_hook {|tc| tc.instance_eval(&block) }
      end

      module Extension
        def temporaries_adapter
          MiniTest.new(self)
        end
      end
    end
  end
end
