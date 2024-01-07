require_relative 'base'

module Nunes
  module Presenters
    class Waterfall < Base
      # What is the minimum % width a span should be rendered as. This is so no
      # span is a sliver so small it cannot be seen.
      MIN_WIDTH_PERCENTAGE = 2

      def spans
        __getobj__
      end

      def offset_for(span)
        (100.0 * (span.started_at - started_at) / duration).round(2)
      end

      def width_for(span)
        [(100.0 * span.duration / duration).round(2), MIN_WIDTH_PERCENTAGE].max
      end

      # bg-danger-subtle for redis...
      def color_for(span)
        case span.name
        when /\.active_record/
          'bg-primary-subtle'
        when /\.action_view/
          'bg-info-subtle'
        when /\.active_support/
          'bg-success-subtle'
        when /\.active_job/
          'bg-warning-subtle'
        else
          'bg-secondary-subtle'
        end
      end

      def ordered
        spans.sort_by(&:started_at)
      end

      def root
        @root ||= begin
          root = spans.detect { |span| span.parent_id.nil? }
          raise 'no root span found' unless root

          Presenters::Request.new(root.span)
        end
      end

      def trace_started_at
        root.trace_started_at
      end

      def started_at
        root.started_at
      end

      def finished_at
        spans.max_by(&:finished_at).finished_at
      end

      def duration
        @duration ||= finished_at - started_at
      end

      def parent_for(span)
        spans.detect { |s| s.id == span.parent_id }
      end

      def children_for(span)
        (by_parent_id[span.id] || []).sort_by!(&:started_at)
      end

      private

      def by_parent_id
        @by_parent_id ||= spans.group_by(&:parent_id)
      end
    end
  end
end
