require_relative "tag"

module Nunes
  class Tracer
    class Span
      # Returns the name of the span.
      attr_reader :name

      # Returns the Array of child spans.
      attr_reader :spans

      # Returns the parent span or nil if no parent span (ie: root).
      attr_reader :parent

      # Returns the start time of the span.
      attr_reader :started_at

      # Returns the time the span was finished.
      attr_reader :finished_at

      # Returns the Array of tags if there are any else nil.
      attr_reader :tags

      def initialize(name:, parent: nil, tags: nil)
        @name = name
        @parent = parent
        @parent.spans << self if parent
        @spans = []
        @tags = Tag.from_hash(tags)
      end

      def start
        @started_at = Nunes.now
      end

      def finish
        @finished_at = Nunes.now
      end

      # Returns the duration in milliseconds that this span lasted.
      def duration
        return @duration if defined?(@duration)

        @duration = if finished_at && started_at
          finished_at - started_at
        else
          nil
        end
      end

      def span(name, options = nil, &block)
        original_span = current_span
        tags = options && options[:tags] ? options[:tags] : nil
        self.current_span = Span.new(parent: original_span, name: name, tags: tags)
        current_span.time(&block)
      ensure
        self.current_span = original_span
      end

      def time(&block)
        start
        yield self
      ensure
        finish
      end

      def tag(key, value)
        self.tags ||= []
        self.tags << Tag.new(key, value)
      end

      def error
        tag(:error, true)
      end

      def descendants
        descendants = []
        spans.each do |span|
          descendants << span
          if span.spans.any?
            descendants.concat span.descendants
          end
        end
        descendants
      end

      def eql?(other)
        self.class.eql?(other.class) &&
          @name == other.name &&
          @parent == other.parent &&
          @spans == other.spans &&
          @tags == other.tags &&
          @started_at == other.started_at &&
          @finished_at == other.finished_at
      end
      alias_method :==, :eql?

      private

      def current_span
        @current_span ||= self
      end

      def current_span=(span)
        @current_span = span
      end
    end
  end
end
