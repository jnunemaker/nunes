module Nunes
  module Adapters
    class ActiveRecord
      def all
        Span.root.by_recent.includes(:tags).all.map { |root| record_to_span(root) }
      end

      def record_to_span(record)
        span = Nunes::Tracer::Span.new(name: record.name)
        record.tags.each { |tag| span.tag(tag.key, tag.value) }
        span.instance_variable_set(:@started_at, record.started_at)
        span.instance_variable_set(:@finished_at, record.finished_at)
        span
      end

      def get(id)
        if root = Span.joins(:tags).where(tags: {key: :id, value: id}).first
          record_to_span(root)
        end
      end

      def save(span)
        Span.transaction do
          root = Span.create!(
            parent_id: nil,
            name: span.name,
            started_at: span.started_at,
            finished_at: span.finished_at,
          )
          span.tags.each do |tag|
            root.tags.create!(
              key: tag.key,
              value: tag.value,
            )
          end

          # FIXME: Store children spans with parents as well...
        end
      end
    end
  end
end
