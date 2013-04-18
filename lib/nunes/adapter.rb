module Nunes
  class Adapter
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
