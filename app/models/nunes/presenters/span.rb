# frozen_string_literal: true

require_relative "base"

module Nunes
  module Presenters
    class Span < Base
      def span
        __getobj__
      end

      def title
        case name
        when "request"
          "#{span[:verb]} #{span[:path]}"
        when "start_processing.action_controller"
          "Start " + span[:controller] + "#" + span[:action]
        when "process_action.action_controller"
          "Finish " + span[:controller] + "#" + span[:action]
        when "sql.active_record"
          span[:name].presence || name
        when "render_partial.action_view", "render_collection.action_view", "render_layout.action_view", "render_template.action_view"
          "View " + clean_path(span[:identifier])
        else
          name
        end
      end

      def preview
        case name
        when "start_processing.action_controller", "process_action.action_controller"
          name
        when "sql.active_record"
          span[:sql]
        when "instantiation.active_record"
          "#{span[:class_name]} (#{span[:record_count]})"
        when "send_file.action_controller"
          span[:path]
        end
      end

      private

      def clean_path(path)
        path.to_s
            .gsub(/#{Rails.root}/, "")
            .gsub(%r{^/app/views/}, "")
      end
    end
  end
end
