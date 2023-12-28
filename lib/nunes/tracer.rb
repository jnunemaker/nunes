module Nunes
  class Tracer
    class MissingRootSpan < StandardError
      def initialize(message = nil)
        super(message || "Missing root span. You need to start the first span using trace.")
      end
    end

    class TraceAlreadyStarted < StandardError
      def initialize(message = nil)
        super(message || "A trace has already been started. You cannot start a trace inside of a trace. Use span instead.")
      end
    end

    def initialize
      @root_span = nil
    end

    def trace(request_id, tags: nil, &block)
      raise TraceAlreadyStarted if @root_span
      @root_span = Span.new(name: request_id, tags: tags)
      yield @root_span
    ensure
      @root_span = nil
    end

    def span(name, options = nil, &block)
      root_span.span(name, options, &block)
    end

    def spans
      root_span.spans
    end

    private

    def root_span
      @root_span || raise(MissingRootSpan)
    end
  end
end

require_relative "tracer/span"
