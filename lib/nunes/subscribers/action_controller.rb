require "nunes/subscriber"

module Nunes
  module Subscribers
    class ActionController < ::Nunes::Subscriber
      # Private
      Pattern = /\.action_controller\Z/

      # Private: The namespace for events to subscribe to.
      def self.pattern
        Pattern
      end

      def process_action(start, ending, transaction_id, payload)
        controller = payload[:controller]
        action = payload[:action]
        status = payload[:status]
        exception_info = payload[:exception]

        format = payload[:format] || "all"
        format = "all" if format == "*/*"

        db_runtime = payload[:db_runtime]
        db_runtime = db_runtime.round if db_runtime

        view_runtime = payload[:view_runtime]
        view_runtime = view_runtime.round if view_runtime

        runtime = ((ending - start) * 1_000).round

        timing "action_controller.runtime.total", runtime
        timing "action_controller.runtime.view", view_runtime if view_runtime
        timing "action_controller.runtime.db",   db_runtime   if db_runtime

        increment "action_controller.format.#{format}" if format
        increment "action_controller.status.#{status}" if status

        if controller && action
          namespace = "action_controller.controller.#{controller}.#{action}"

          timing "#{namespace}.runtime.total",      runtime
          timing "#{namespace}.runtime.view", view_runtime if view_runtime
          timing "#{namespace}.runtime.db",   db_runtime   if db_runtime

          increment "#{namespace}.format.#{format}" if format
          increment "#{namespace}.status.#{status}" if status

        end

        if exception_info
          exception_class, exception_message = exception_info

          increment "action_controller.exception.#{exception_class}"
        end
      end

      ##########################################################################
      # All of the events below don't really matter. Most of them also go      #
      # through process_action. The only value that could be pulled from them  #
      # would be topk related which graphite doesn't do.                       #
      ##########################################################################

      def start_processing(*)
        # noop
      end

      def halted_callback(*)
        # noop
      end

      def redirect_to(*)
        # noop
      end

      def send_file(*)
        # noop
      end

      def send_data(*)
        # noop
      end
    end
  end
end
