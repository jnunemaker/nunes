# frozen_string_literal: true

require_relative "base"

module Nunes
  module Presenters
    class Waterfall < Base
      # What is the minimum % width a span should be rendered as. This is so no
      # span is a sliver so small it cannot be seen.
      MIN_WIDTH_PERCENTAGE = 2

      delegate :start_timestamp, to: :root
      delegate :end_timestamp, to: :root

      def spans
        __getobj__
      end

      def offset_for(span)
        start_offset = (span.start_timestamp - start_timestamp) / 1000.0
        (100.0 * start_offset / duration).round(2)
      end

      def width_for(span)
        [(100.0 * span.duration / duration).round(2), MIN_WIDTH_PERCENTAGE].max
      end

      # bg-danger-subtle for redis...
      def color_for(span)
        case span.name
        when /\.active_record/
          "bg-primary-subtle"
        when /\.action_view/
          "bg-info-subtle"
        when /\.active_support/
          "bg-success-subtle"
        when /\.active_job/
          "bg-warning-subtle"
        else
          "bg-secondary-subtle"
        end
      end

      def ordered
        spans.sort_by(&:start_timestamp)
      end

      def root
        @root ||= begin
          root = spans.detect(&:root?)
          raise "no root span found" unless root

          Presenters::Request.new(root.span)
        end
      end

      def duration
        @duration ||= (end_timestamp - start_timestamp) / 1000.0
      end

      def parent_for(span)
        spans.detect { |s| s.id == span.parent_id }
      end

      def children_for(span)
        (by_parent_id[span.id] || []).sort_by!(&:start_timestamp)
      end

      private

      def by_parent_id
        @by_parent_id ||= spans.group_by(&:parent_id)
      end
    end
  end
end
