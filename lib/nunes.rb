require "nunes/instrumentable"

require "nunes/adapters/memory"
require "nunes/adapters/timing_aliased"

require "nunes/subscriber"
require "nunes/subscribers/action_controller"
require "nunes/subscribers/action_view"
require "nunes/subscribers/action_mailer"
require "nunes/subscribers/active_support"
require "nunes/subscribers/active_record"
require "nunes/subscribers/active_job"
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
    adapter = Nunes::Adapter.wrap(client)

    subscribers << Subscribers::ActionController.subscribe(adapter)
    subscribers << Subscribers::ActionView.subscribe(adapter)
    subscribers << Subscribers::ActionMailer.subscribe(adapter)
    subscribers << Subscribers::ActiveSupport.subscribe(adapter)
    subscribers << Subscribers::ActiveRecord.subscribe(adapter)
    subscribers << Subscribers::ActiveJob.subscribe(adapter)
    subscribers << Subscribers::Nunes.subscribe(adapter)

    subscribers
  end

  # Private: What ruby uses to separate namespaces.
  NAMESPACE_SEPARATOR = "::".freeze

  # Private: What nunes uses to separate namespaces in the metric.
  METRIC_NAMESPACE_SEPARATOR = "-".freeze

  # Private: Converts a class to a metric safe name.
  def self.class_to_metric(class_or_class_name)
    return if class_or_class_name.nil?
    class_or_class_name.to_s.gsub(NAMESPACE_SEPARATOR, METRIC_NAMESPACE_SEPARATOR)
  end
end
