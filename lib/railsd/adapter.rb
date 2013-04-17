module Railsd
  class Adapter
    # Internal
    def initialize(client)
      @client = client
    end

    # Internal: Override in subclass if interface does not match.
    def increment(metric, value = 1)
      @client.increment metric, value
    end

    # Internal: Override in subclass if interface does not match.
    def timing(metric, duration)
      @client.timing metric, duration
    end
  end
end
