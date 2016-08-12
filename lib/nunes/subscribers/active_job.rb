require "nunes/subscriber"

module Nunes
  module Subscribers
    class ActiveJob < ::Nunes::Subscriber
      # Private
      Pattern = /\.active_job\Z/

      # Private: The namespace for events to subscribe to.
      def self.pattern
        Pattern
      end

      def perform(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        job = ::Nunes.class_to_metric(payload[:job].class)

        timing "active_job.#{job}.perform", runtime
      end

      def enqueue(start, ending, transaction_id, payload)
        job = ::Nunes.class_to_metric(payload[:job].class)
        increment "active_job.#{job}.enqueue"
      end
    end
  end
end
