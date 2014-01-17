module Temporaries
  module Adapters
    class TestUnit < Base
      include Shared

      def self.install(mod)
        mod::TestCase.class_eval do
          extend Extension
          include Values
          include Directory
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
