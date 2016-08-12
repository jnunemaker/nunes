require "nunes/subscriber"

module Nunes
  module Subscribers
    class ActionMailer < ::Nunes::Subscriber
      # Private
      Pattern = /\.action_mailer\Z/

      # Private: The namespace for events to subscribe to.
      def self.pattern
        Pattern
      end

      def deliver(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        mailer = ::Nunes.class_to_metric(payload[:mailer])

        if mailer
          timing "action_mailer.deliver.#{mailer}", runtime
        end
      end

      def receive(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        mailer = ::Nunes.class_to_metric(payload[:mailer])

        if mailer
          timing "action_mailer.receive.#{mailer}", runtime
        end
      end
    end
  end
end
