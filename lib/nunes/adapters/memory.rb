# frozen_string_literal: true

require "moneta"

module Nunes
  module Adapters
    class Memory
      INDEX_KEY = "traces"

      def initialize
        @storage = Moneta.new(:Memory, threadsafe: true)
      end

      def index
        @storage[INDEX_KEY] || []
      end

      def get_multi(*request_ids)
        request_ids = Array(request_ids).flatten.compact.map(&:to_s)
        return {} if request_ids.empty?
        Hash[request_ids.zip(@storage.values_at(*trace_keys(request_ids)))]
      end

      def get(request_id)
        @storage[trace_key(request_id)]
      end

      def save(request_id, span)
        trace_key = trace_key(request_id)

        if @storage.create(trace_key, span)
          @storage.store(INDEX_KEY, index.unshift(request_id))
        end
      end

      private

      def trace_keys(request_ids)
        request_ids.map { |request_id| trace_key(request_id) }
      end

      def trace_key(request_id)
        "trace/#{request_id}"
      end
    end
  end
end
