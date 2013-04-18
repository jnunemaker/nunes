require "nunes/subscriber"

module Nunes
  module Subscribers
    class ActiveRecord < ::Nunes::Subscriber
      # Private
      Pattern = /\.active_record\Z/

      # Private: The namespace for events to subscribe to.
      def self.pattern
        Pattern
      end

      def sql(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        name = payload[:name]
        sql = payload[:sql].to_s.strip
        operation = sql.split(' ', 2).first.to_s.downcase

        timing "active_record.sql", runtime

        case operation
        when "begin"
          timing "active_record.sql.transaction_begin", runtime
        when "commit"
          timing "active_record.sql.transaction_commit", runtime
        else
          timing "active_record.sql.#{operation}", runtime
        end
      end
    end
  end
end
