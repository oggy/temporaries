module Temporaries
  module Adapters
    class MiniTest < Base
      include Shared

      def self.install
        ::MiniTest::Spec.class_eval do
          extend Extension
          include Values
          include Directory
        end
      end

      module Extension
        def temporaries_adapter
          MiniTest.new(self)
        end
      end
    end
  end
end
