module Temporaries
  module Adapters
    class RSpec < Base
      def self.install
        Spec::Runner.configure do |config|
          config.extend Extension
          config.include Values
          config.include Directory
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
          RSpec.new(self)
        end
      end
    end
  end
end
