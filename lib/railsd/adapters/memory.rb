require "railsd/adapter"

module Railsd
  module Adapters
    class Memory < ::Railsd::Adapter
      def initialize(client = nil)
        @client = client || {}
        clear
      end

      def increment(metric, value = 1)
        counters << [metric, value]
      end

      def timing(metric, value)
        timers << [metric, value]
      end

      def timers
        @client.fetch(:timers)
      end

      def timer_metric_names
        timers.map { |op| op.first }
      end

      def timer?(metric)
        timers.detect { |op| op.first == metric }
      end

      def counters
        @client.fetch(:counters)
      end

      def counter_metric_names
        counters.map { |op| op.first }
      end

      def counter?(metric)
        counters.detect { |op| op.first == metric }
      end

      def clear
        @client ||= {}
        @client.clear
        @client[:timers] = []
        @client[:counters] = []
      end
    end
  end
end
