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
        instrument_identifier :template, payload[:identifier], start, ending
      end

      def render_partial(start, ending, transaction_id, payload)
        instrument_identifier :partial, payload[:identifier], start, ending
      end

      private

      # Private: Sends timing information about identifier event.
      def instrument_identifier(kind, identifier, start, ending)
        if identifier
          runtime = ((ending - start) * 1_000).round
          timing identifier_to_metric(kind, identifier), runtime
        end
      end

      # Private: What to replace file separators with.
      FileSeparatorReplacement = "_"

      # Private: Converts an identifier to a metric name. Strips out the rails
      # root from the full path.
      #
      # identifier - The String full path to the template or partial.
      def identifier_to_metric(kind, identifier)
        view_path = identifier.to_s.gsub(::Rails.root.to_s, "")
        metric = adapter.prepare(view_path, FileSeparatorReplacement)
        "action_view.#{kind}.#{metric}"
      end
    end
  end
end
