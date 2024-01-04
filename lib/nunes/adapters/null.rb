module Nunes
  module Adapters
    class Null
      def all
        []
      end

      def get(_trace_id)
        nil
      end

      def save(_context)
        nil
      end
    end
  end
end
