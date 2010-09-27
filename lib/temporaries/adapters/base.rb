module Temporaries
  module Adapters
    class Base
      def initialize(context)
        @context = context
      end

      attr_reader :context

      def before
        raise NotImplementedError, 'abstract'
      end

      def after
        raise NotImplementedError, 'abstract'
      end
    end
  end
end
