require_relative "adapters/moneta"

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
      @adapter = adapter || Adapters::Moneta.new
    end

    def trace(name, tags: nil, &block)
      raise TraceAlreadyStarted if @root_span
      tags ||= {}
      tags[:id] ||= SecureRandom.uuid
      @root_span = Span.new(name: name.to_s, tags: tags)
      begin
        @root_span.time { |span| yield span }
      ensure
        adapter.save(tags[:id], @root_span)
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
