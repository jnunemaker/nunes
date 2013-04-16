module Railsd
  class Subscriber
    BANG = '!'

    # Public: Subscribe to a pattern of event notifications.
    #
    # match - The String or Regexp to subscribe to.
    #
    # Returns nothing.
    def self.subscribe(match, client)
      ActiveSupport::Notifications.subscribe match, new(client)
    end

    def initialize(client)
      @client = client
    end

    # Private: Dispatcher that converts incoming events to method calls.
    def call(name, start, ending, transaction_id, payload)
      # rails doesn't recommend instrumenting methods that start with bang
      # when in production
      return if name.starts_with?(BANG)

      method_name = name.split('.').first

      if respond_to?(method_name)
        send(method_name, start, ending, transaction_id, payload)
      else
        $stderr.puts "#{self.class.name} did not respond to #{method_name} therefore it cannot instrument the event named #{name}."
      end
    end

    # Internal: Count a metric with statsd client.
    #
    # metric - The String name of the metric to increment.
    #
    # Returns nothing.
    def count(metric)
      if @client
        @client.increment metric
      end
    end

    # Internal: Tracking the timing of a metric with statsd client.
    #
    # metric - The String name of the metric.
    # duration_in_ms - The Integer duration of the event in milliseconds.
    #
    # Returns nothing.
    def timing(metric, duration_in_ms)
      if @client
        @client.timing metric, duration_in_ms
      end
    end
  end
end
