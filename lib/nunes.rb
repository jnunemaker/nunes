require "nunes/instrumentable"

require "nunes/adapters/memory"
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
  # prefix - Optional prefix to all generated metric names.
  #
  # Examples:
  #
  #   Nunes.subscribe(Statsd.new)
  #   Nunes.subscribe(Instrumental::Agent.new)
  #
  #   Nunes.subscribe(Statsd.new, 'a.prefix')
  #   Nunes.subscribe(Instrument::Agent.new, 'another.prefix')
  #
  # Returns Array of subscribers that were setup.

  def self.subscribe(client, prefix=nil)
    subscribers = []

    adapter = Nunes::Adapter.wrap(client, prefix)

    subscribers << Subscribers::ActionController.subscribe(adapter)
    subscribers << Subscribers::ActionView.subscribe(adapter)
    subscribers << Subscribers::ActionMailer.subscribe(adapter)
    subscribers << Subscribers::ActiveSupport.subscribe(adapter)
    subscribers << Subscribers::ActiveRecord.subscribe(adapter)
    subscribers << Subscribers::Nunes.subscribe(adapter)

    subscribers
  end
end
