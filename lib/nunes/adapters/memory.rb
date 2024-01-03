require 'thread'

module Nunes
  module Adapters
    class Memory
      def initialize(storage = {})
        @storage = storage
        @mutex = Mutex.new
      end

      def all
        @mutex.synchronize do
          @storage.values.map do |spans|
            spans.detect { |span| span.parent_id.nil? }
          end
        end
      end

      def get(trace_id)
        @mutex.synchronize { @storage[trace_id] }
      end

      def save(context)
        @mutex.synchronize { @storage[context[:trace_id]] = context[:spans] }
      end
    end
  end
end
