module Nunes
  class Adapter
    # Private: Wraps a given object with the correct adapter/decorator.
    #
    # client - The thing to be wrapped.
    #
    # Returns Nunes::Adapter instance.
    def self.wrap(client)
      if client.nil?
        raise ArgumentError.new("client cannot be nil")
      end

      if client.is_a?(self)
        return client
      end

      if client.is_a?(Hash)
        return Adapters::Memory.new(client)
      end

      has_increment = client.respond_to?(:increment)
      has_timing = client.respond_to?(:timing)
      has_gauge = client.respond_to?(:gauge)

      if has_increment && has_timing
        Adapters::Default.new(client)
      elsif has_increment && has_gauge && !has_timing
        Adapters::TimingAliased.new(client)
      else
        raise "I have no clue how to wrap what you've given me (#{client.inspect})"
      end
    end

    # Private
    attr_reader :client

    # Internal: Sets the client for the adapter.
    #
    # client - The thing being adapted to a simple interface.
    def initialize(client)
      @client = client
    end

    # Internal: Increment a metric by a value. Override in subclass if client
    # interface does not match.
    def increment(metric, value = 1)
      @client.increment metric, value
    end

    # Internal: Record a metric's duration. Override in subclass if client
    # interface does not match.
    def timing(metric, duration)
      @client.timing metric, duration
    end
  end
end
