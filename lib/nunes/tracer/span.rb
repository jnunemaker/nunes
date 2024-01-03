require_relative 'tag'

module Nunes
  class Tracer
    class Span
      attr_reader :id, :name, :trace_id, :parent_id, :tags, :started_at, :finished_at

      def initialize( # rubocop:disable Metrics/ParameterLists
        name:,
        tags: nil,
        parent_id: nil,
        started_at: nil,
        finished_at: nil,
        trace_id: SecureRandom.uuid,
        id: SecureRandom.uuid
      )
        @id = id
        @name = name
        @trace_id = trace_id
        @parent_id = parent_id
        @started_at = started_at
        @finished_at = finished_at
        @tags = Tag.from_hash(tags)
      end

      def start
        @started_at = Nunes.now
      end

      def finish
        @finished_at = Nunes.now
      end

      def time
        start
        begin
          yield self
        rescue StandardError => e
          tag(:error, e.inspect)
          raise
        end
      ensure
        finish
      end

      def [](key)
        tags.find { |tag| tag.key == key.to_sym }&.value
      end

      def duration
        finished_at - started_at if finished_at && started_at
      end

      def tag(key, value)
        self.tags ||= []
        self.tags << Tag.new(key, value)
      end

      def eql?(other) # rubocop:disable Metrics/CyclomaticComplexity
        self.class.eql?(other.class) &&
          @id == other.id &&
          @trace_id == other.trace_id &&
          @parent_id == other.parent_id &&
          @name == other.name &&
          @tags == other.tags &&
          @started_at == other.started_at &&
          @finished_at == other.finished_at
      end
      alias == eql?
    end
  end
end
