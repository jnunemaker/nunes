module Nunes
  module Adapters
    class Null
      def all
        []
      end

      def get(id)
        nil
      end

      def save(span)
        nil
      end
    end
  end
end
