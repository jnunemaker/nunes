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

      class << self
        attr_accessor :instrument_format
        attr_accessor :instrument_view_runtime
        attr_accessor :instrument_db_runtime
      end

      # Public: Should we instrument the number of requests per format overall and per controller/action.
      self.instrument_format = true

      # Public: Should we instrument the view runtime overall and per controller/action.
      self.instrument_view_runtime = true

      # Public: Should we instrument the db runtime overall and per controller/action.
      self.instrument_db_runtime = true

      def process_action(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        timing "action_controller.runtime.total", runtime

        status = payload[:status]
        increment "action_controller.status.#{status}" if status

        controller = payload[:controller]
        action = payload[:action]

        if controller && action
          timing "action_controller.controller.#{controller}.#{action}.runtime.total", runtime
          increment "action_controller.controller.#{controller}.#{action}.status.#{status}" if status
        end

        if self.class.instrument_view_runtime
          view_runtime = payload[:view_runtime]
          view_runtime = view_runtime.round if view_runtime

          if view_runtime
            timing "action_controller.runtime.view", view_runtime

            if controller && action
              timing "action_controller.controller.#{controller}.#{action}.runtime.view", view_runtime
            end
          end
        end

        if self.class.instrument_db_runtime
          db_runtime = payload[:db_runtime]
          db_runtime = db_runtime.round if db_runtime

          if db_runtime
            timing "action_controller.runtime.db", db_runtime

            if controller && action
              timing "action_controller.controller.#{controller}.#{action}.runtime.db", db_runtime
            end
          end
        end

        if self.class.instrument_format
          format = payload[:format] || "all"
          format = "all" if format == "*/*"

          if format
            increment "action_controller.format.#{format}"

            if controller && action
              increment "action_controller.controller.#{controller}.#{action}.format.#{format}"
            end
          end
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
