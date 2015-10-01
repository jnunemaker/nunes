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

      def process_job(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        name = payload[:name]
        sql = payload[:sql].to_s.strip
        operation = sql.split(' ', 2).first.to_s.downcase

        timing "active_job.perform", runtime

        case operation
        when "enqueue_at.active_job"
        when "enqueue.active_job"
        when "perform_start.active_job"
        when "perform.active_job"
        else
          puts operation.inspect
        end
      end
    end
  end
end

