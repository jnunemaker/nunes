module Nunes
  module Adapters
    class Memory
      def initialize(storage = [])
        @storage = storage
      end

      def all
        @storage
      end

      def get(id)
        @storage.detect { |span| span.tags.detect { |tag| tag.key == :id && tag.value == id } }
      end

      def save(span)
        @storage.unshift(span)
      end
    end
  end
end
