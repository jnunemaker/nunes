# frozen_string_literal: true

module Nunes
  module Adapters
    class ActiveRecord
      def all
        records = Span.roots.order(created_at: :desc).includes(:tags).load
        records.map do |record|
          record_to_span(record)
        end
      end

      def get(trace_id)
        spans = Span.where(trace_id:).map do |record|
          record_to_span(record)
        end

        spans.blank? ? nil : spans
      end

      def save(context)
        Span.transaction do
          context[:spans].each do |span|
            record = Span.create!(
              name: span.name,
              span_id: span.id,
              trace_id: span.trace_id,
              parent_id: span.parent_id,
              started_at: span.started_at,
              finished_at: span.finished_at
            )
            span.tags.each do |key, value|
              record.tags.create!(key:, value:)
            end
          end
        end

        true
      rescue ::ActiveRecord::ActiveRecordError => e
        raise if Rails.env.test?

        Rails.logger.error(e)
        false
      end

      private

      def record_to_span(record)
        Tracer::Span.new(
          id: record.span_id,
          name: record.name,
          trace_id: record.trace_id,
          parent_id: record.parent_id,
          started_at: record.started_at,
          finished_at: record.finished_at,
          tags: Hash[record.tags.map { |tag| [tag.key, tag.value] }]
        )
      end
    end
  end
end
