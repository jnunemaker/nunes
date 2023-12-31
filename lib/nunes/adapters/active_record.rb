module Nunes
  module Adapters
    class ActiveRecord
      def all
        Span.order(created_at: :desc).includes(:tags).all.map(&:from_uid)
      end

      def get(id)
        if record = Span.joins(:tags).where(tags: {key: :id, value: id}).first
          record.from_uid
        end
      end

      def save(span)
        Span.transaction do
          record = Span.create!(
            name: span.name,
            data: span.to_uid,
          )
          span.tags.each do |tag|
            record.tags.create!(
              key: tag.key,
              value: tag.value,
            )
          end
        end

        true
      rescue ActiveRecord::ActiveRecordError => e
        Rails.logger.error(e)
        false
      end
    end
  end
end
