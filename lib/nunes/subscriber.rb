require "active_support/notifications"

module Nunes
  class Subscriber
    # Private: The bang character that is the first char of some events.
    BANG = '!'

    # Public: Setup a subscription for the subscriber using the
    # provided adapter.
    #
    # adapter - The adapter instance to send instrumentation to.
    def self.subscribe(adapter, options = {})
      subscriber = options.fetch(:subscriber) { ActiveSupport::Notifications }
      subscriber.subscribe pattern, new(adapter)
    end

    def self.pattern
      raise "Not Implemented, override in subclass and provide a regex or string."
    end

    # Private: The adapter to send instrumentation to.
    attr_reader :adapter

    # Internal: Initializes a new instance.
    #
    # adapter - The adapter instance to send instrumentation to.
    def initialize(adapter)
      @adapter = Nunes::Adapter.wrap(adapter)
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

    # Internal: Increment a metric for the client.
    #
    # metric - The String name of the metric to increment.
    #
    # Returns nothing.
    def increment(metric)
      @adapter.increment metric
    end

    # Internal: Track the timing of a metric for the client.
    #
    # metric - The String name of the metric.
    # duration_in_ms - The Integer duration of the event in milliseconds.
    #
    # Returns nothing.
    def timing(metric, duration_in_ms)
      @adapter.timing metric, duration_in_ms
    end
  end
end
