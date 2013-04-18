require "nunes/instrumentable"

require "nunes/adapters/memory"
require "nunes/adapters/default"
require "nunes/adapters/timing_aliased"

require "nunes/subscriber"
require "nunes/subscribers/action_controller"
require "nunes/subscribers/action_view"
require "nunes/subscribers/action_mailer"
require "nunes/subscribers/active_support"
require "nunes/subscribers/active_record"
require "nunes/subscribers/nunes"

module Nunes
  # Public: Shortcut method to setup all subscribers for a given client.
  #
  # client - The instance that will be adapted and receive all instrumentation.
  #
  # Examples:
  #
  #   Nunes.subscribe(Statsd.new)
  #   Nunes.subscribe(Instrumental::Agent.new)
  #
  # Returns Array of subscribers that were setup.
  def self.subscribe(client)
    subscribers = []
    adapter = to_adapter(client)

    subscribers << Subscribers::ActionController.subscribe(adapter)
    subscribers << Subscribers::ActionView.subscribe(adapter)
    subscribers << Subscribers::ActionMailer.subscribe(adapter)
    subscribers << Subscribers::ActiveSupport.subscribe(adapter)
    subscribers << Subscribers::ActiveRecord.subscribe(adapter)
    subscribers << Subscribers::Nunes.subscribe(adapter)

    subscribers
  end

  # Private: Wraps a given object with the correct adapter/decorator.
  #
  # client - The thing to be wrapped.
  #
  # Returns Nunes::Adapter instance.
  def self.to_adapter(client)
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
end
