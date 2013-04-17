require "railsd/instrumentable"

require "railsd/adapters/instrumental"
require "railsd/adapters/statsd"

require "railsd/subscriber"
require "railsd/subscribers/action_controller"
require "railsd/subscribers/action_view"
require "railsd/subscribers/action_mailer"
require "railsd/subscribers/active_support"
require "railsd/subscribers/active_record"
require "railsd/subscribers/railsd"

module Railsd
  # Public: Shortcut method to setup all subscribers for a given client.
  #
  # client - The statsd instance that will receive all instrumentation.
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
    subscribers << Subscribers::Railsd.subscribe(adapter)

    subscribers
  end

  # Private: Wraps a given object with the correct adapter/decorator.
  #
  # client - The thing to be wrapped.
  #
  # Returns Railsd::Adapter instance.
  def self.to_adapter(client)
    if Object.const_defined?(:Instrumental) &&
      Instrumental.const_defined?(:Agent) &&
      client.is_a?(Instrumental::Agent)
      Adapters::Instrumental.new(client)
    else
      Adapters::Statsd.new(client)
    end
  end
end
