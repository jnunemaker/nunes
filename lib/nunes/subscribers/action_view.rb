require "nunes/subscriber"

module Nunes
  module Subscribers
    class ActionView < ::Nunes::Subscriber
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
        rails_root = ::Rails.root.to_s + File::SEPARATOR
        view_path = identifier.gsub(rails_root, '')
        "action_view.#{view_path}" if view_path
      end
    end
  end
end
