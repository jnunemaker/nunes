require "railsd/instrumentable"
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

    subscribers << Subscribers::ActionController.subscribe(client)
    subscribers << Subscribers::ActionView.subscribe(client)
    subscribers << Subscribers::ActionMailer.subscribe(client)
    subscribers << Subscribers::ActiveSupport.subscribe(client)
    subscribers << Subscribers::ActiveRecord.subscribe(client)
    subscribers << Subscribers::Railsd.subscribe(client)

    subscribers
  end
end
