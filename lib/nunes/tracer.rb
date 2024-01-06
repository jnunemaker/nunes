require_relative 'adapters/memory'

module Nunes
  class Tracer
    class MissingRootSpan < StandardError
      def initialize(message = nil)
        super(message || 'Missing root span. You need to start the first span using trace.')
      end
    end

    class TraceAlreadyStarted < StandardError
      def initialize(message = nil)
        super(message || 'A trace has already been started. You cannot start a trace inside of a trace. Use span instead.')
      end
    end

    def self.reset
      Thread.current[:nunes_tracer_context] = { spans: [] }
    end

    attr_reader :adapter

    def initialize(adapter: Adapters::Memory.new)
      @adapter = adapter
      reset
    end

    def reset
      self.class.reset
    end

    # Don't use this unless you are me.
    def manual_trace(...)
      span = Span.new(...)
      spans << span
      span
    end

    def trace(name, tags: nil, &block)
      name = name.to_s
      context[:trace_id] ||= SecureRandom.uuid
      original_span = active_span
      result = nil
      span = Span.new(name:, tags:, trace_id:, parent_id: original_span&.id)
      spans << span
      with_active_span(span) { result = span.time(&block) }
      result
    ensure
      if original_span.nil?
        begin
          @adapter.save(context)
        ensure
          reset
        end
      end
    end

    def trace_id
      context[:trace_id]
    end

    def with_active_span(span)
      original = active_span
      self.active_span = span
      yield
    ensure
      self.active_span = original
    end

    def active_span
      context[:active_span]
    end

    def active_span=(span)
      context[:active_span] = span
    end

    def spans
      context[:spans]
    end

    private

    def context
      Thread.current[:nunes_tracer_context]
    end
  end
end

require_relative 'tracer/span'
