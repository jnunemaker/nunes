require "railsd/subscriber"

module Railsd
  module Subscribers
    class ActionController < ::Railsd::Subscriber
      def self.subscribe(client)
        super /\.action_controller\Z/, client
      end

      def start_processing(start, ending, transaction_id, payload)
        # noop, not worried about tracking these
      end

      def halted_callback(start, ending, transaction_id, payload)
        # noop, not worried about tracking these
      end

      def redirect_to(start, ending, transaction_id, payload)
        # noop, not worried about tracking these, technically, the number of
        # redirect statuses is tracked in process_action
      end

      def send_file(*)
        # noop
      end

      def send_data(*)
        # noop
      end

      # Internal: Send process_action event information to statsd.
      #
      # start - The Time when the event started.
      # ending - The Time when the event stopped.
      # transaction_id - The String transaction_id for the event.
      # payload - The Hash payload of information about the event.
      #
      # Returns nothing.
      def process_action(start, ending, transaction_id, payload)
        controller = payload[:controller].to_s.gsub('Controller', '').underscore
        action = payload[:action]
        status = payload[:status]

        format = payload[:format] || "all"
        format = "all" if format == "*/*"

        db_runtime = payload[:db_runtime]
        db_runtime = db_runtime.round if db_runtime

        view_runtime = payload[:view_runtime]
        view_runtime = view_runtime.round if view_runtime

        runtime = ((ending - start) * 1_000).round

        timing "action_controller.runtime",      runtime      if runtime
        timing "action_controller.view_runtime", view_runtime if view_runtime
        timing "action_controller.db_runtime",   db_runtime   if db_runtime

        count  "action_controller.format.#{format}" if format
        count  "action_controller.status.#{status}" if status

        if controller && action
          namespace = "action_controller.#{controller}.#{action}"

          timing "#{namespace}.runtime",      runtime      if runtime
          timing "#{namespace}.view_runtime", view_runtime if view_runtime
          timing "#{namespace}.db_runtime",   db_runtime   if db_runtime
        end
      end
    end
  end
end
