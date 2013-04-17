require "railsd/subscriber"

module Railsd
  module Subscribers
    class Railsd < ::Railsd::Subscriber
      Pattern = /\.railsd\Z/

      def self.pattern
        Pattern
      end

      def instrument_method_time(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        metric = payload[:metric]

        if metric
          timing "#{metric}", runtime
        end
      end
    end
  end
end
