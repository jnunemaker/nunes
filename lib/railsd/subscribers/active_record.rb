require "railsd/subscriber"

module Railsd
  module Subscribers
    class ActiveRecord < ::Railsd::Subscriber
      SqlName = 'SQL'
      Pattern = /\.active_record\Z/

      def self.pattern
        Pattern
      end

      def sql(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        name = payload[:name]
        sql = payload[:sql].to_s.strip

        timing "active_record.sql", runtime

        operation = sql.split(' ', 2).first.to_s.downcase
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
