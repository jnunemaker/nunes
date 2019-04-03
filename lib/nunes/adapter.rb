module Nunes
  class Adapter
    # Private: Wraps a given object with the correct adapter/decorator.
    #
    # client - The thing to be wrapped.
    #
    # Returns Nunes::Adapter instance.
    def self.wrap(client)
      raise ArgumentError, "client cannot be nil" if client.nil?
      return client if client.is_a?(self)

      adapter = adapters.detect { |adapter| adapter.wraps?(client) }

      if adapter.nil?
        raise ArgumentError,
          "I have no clue how to wrap what you've given me (#{client.inspect})"
      end

      adapter.new(client)
    end

    # Private
    def self.wraps?(client)
      client.respond_to?(:increment) && client.respond_to?(:timing)
    end

    # Private
    def self.adapters
      [Nunes::Adapter, *subclasses]
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
      @client.increment prepare(metric), value
    end

    # Internal: Record a metric's duration. Override in subclass if client
    # interface does not match.
    def timing(metric, duration)
      @client.timing prepare(metric), duration
    end

    # Internal: Adds tag key and value to postfix sent to statsd
    def add_tag(new_tag = {})
      return unless tag_value_changed?(new_tag)

      update_postfix(new_tag)
    end

    def tag_value_changed?(tag)
      index = tag_index(tag[:key])
      current_value = current_tags[index].split('=').last if index.present?
      current_value != tag[:value]
    end

    def update_postfix(tag)
      index = tag_index(tag[:key])
      remove_tag(tag[:key]) if index.present?
      new_postfix = current_tags.join(',') + ",#{tag[:key]}=#{tag[:value]}"
      @client.instance_variable_set(:@postfix, new_postfix)
    end

    def tag_index(key)
      current_tags.index { |tag| tag.include?(key.to_s) }
    end

    def current_tags
      postfix.split(',')
    end

    # Internal: Removes tag in postfix sent to statsd
    def remove_tag(key)
      tags = current_tags
      tags.delete_at(tag_index(key))
      @client.instance_variable_set(:@postfix, tags.join(','))
    end

    def postfix
      @client.instance_variable_get(:@postfix)
    end

    # Private: What Ruby uses to separate namespaces.
    ReplaceRegex = /[^a-z0-9\-_]+/i

    # Private: The default metric namespace separator.
    Separator = "."

    # Private
    Nothing = ""

    # Private: Prepare a metric name before it is sent to the adapter's client.
    def prepare(metric, replacement = Separator)
      escaped = Regexp.escape(replacement)
      replace_begin_end_regex = /\A#{escaped}|#{escaped}\Z/

      metric = metric.to_s.gsub(ReplaceRegex, replacement)
      metric.squeeze!(replacement)
      metric.gsub!(replace_begin_end_regex, Nothing)
      metric
    end
  end
end
