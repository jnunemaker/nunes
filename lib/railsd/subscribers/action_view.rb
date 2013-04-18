require "railsd/subscriber"

module Railsd
  module Subscribers
    class ActionView < ::Railsd::Subscriber
      # Private
      Pattern = /\.action_view\Z/

      # Private: The namespace for events to subscribe to.
      def self.pattern
        Pattern
      end

      def render_template(start, ending, transaction_id, payload)
        instrument_identifier payload[:identifier], start, ending
      end

      def render_partial(start, ending, transaction_id, payload)
        instrument_identifier payload[:identifier], start, ending
      end

      private

      # Private: Sends timing information about identifier event.
      def instrument_identifier(identifier, start, ending)
        if identifier.present?
          runtime = ((ending - start) * 1_000).round
          timing identifier_to_metric(identifier), runtime
        end
      end

      # Private: Converts an identifier to a metric name. Strips out the rails
      # root from the full path.
      #
      # identifier - The String full path to the template or partial.
      def identifier_to_metric(identifier)
        rails_root = ::Rails.root.to_s + '/'
        view_path = identifier.gsub(rails_root, '')
        metric = view_path.gsub('/', '.')
        "action_view.#{metric}"
      end
    end
  end
end
