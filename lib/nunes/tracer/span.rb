# frozen_string_literal: true

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
        @tags = {}

        return unless tags
        raise ArgumentError, 'tags must be a Hash' unless tags.is_a?(Hash)

        tags.each do |key, value|
          tag(key, value)
        end
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
        tags[key.to_sym]
      end

      def duration
        finished_at - started_at if finished_at && started_at
      end

      def tag(key, value)
        self.tags ||= {}
        tags[key.to_sym] = value.to_s
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
