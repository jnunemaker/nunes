require "railsd/subscriber"

module Railsd
  module Subscribers
    class ActionMailer < ::Railsd::Subscriber
      # Private
      Pattern = /\.action_mailer\Z/

      # Private: The namespace for events to subscribe to.
      def self.pattern
        Pattern
      end

      def deliver(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        mailer = payload[:mailer]

        if mailer
          timing "action_mailer.deliver.#{mailer.to_s.underscore}", runtime
        end
      end

      def receive(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        mailer = payload[:mailer]

        if mailer
          timing "action_mailer.receive.#{mailer.to_s.underscore}", runtime
        end
      end
    end
  end
end
