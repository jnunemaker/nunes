require_relative "adapters/memory"

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

    attr_reader :adapter

    def initialize(adapter: nil)
      @root_span = nil
      @adapter = adapter || Adapters::Memory.new
    end

    def trace(request_id, tags: nil, &block)
      raise TraceAlreadyStarted if @root_span
      request_id = request_id.to_s
      @root_span = Span.new(name: request_id, tags: tags)
      begin
        yield @root_span
      ensure
        adapter.save(request_id, @root_span)
      end
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
