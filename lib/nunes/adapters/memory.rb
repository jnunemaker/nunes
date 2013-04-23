require "nunes/adapter"

module Nunes
  module Adapters
    # Internal: Memory backend for recording instrumentation calls. This should
    # never need to be used directly by a user of the gem.
    class Memory < ::Nunes::Adapter
      def self.wraps?(client)
        client.is_a?(Hash)
      end

      def initialize(client = nil)
        @client = client || {}
        clear
      end

      def increment(metric, value = 1)
        counters << [prepare(metric), value]
      end

      def timing(metric, value)
        timers << [prepare(metric), value]
      end

      # Internal: Returns Array of any recorded timers with durations.
      def timers
        @client.fetch(:timers)
      end

      # Internal: Returns Array of only recorded timers.
      def timer_metric_names
        timers.map { |op| op.first }
      end

      # Internal: Returns true/false if metric has been recorded as a timer.
      def timer?(metric)
        timers.detect { |op| op.first == metric }
      end

      # Internal: Returns Array of any recorded counters with values.
      def counters
        @client.fetch(:counters)
      end

      # Internal: Returns Array of only recorded counters.
      def counter_metric_names
        counters.map { |op| op.first }
      end

      # Internal: Returns true/false if metric has been recorded as a counter.
      def counter?(metric)
        counters.detect { |op| op.first == metric }
      end

      # Internal: Empties the known counters and metrics.
      #
      # Returns nothing.
      def clear
        @client ||= {}
        @client.clear
        @client[:timers] = []
        @client[:counters] = []
      end
    end
  end
end
