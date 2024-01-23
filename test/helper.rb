# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"

ENV["RAILS_ENV"] = "test"
require_relative "dummy/config/environment"
Rails.backtrace_cleaner.remove_silencers!

require "nunes"

ActiveSupport::TestCase.setup do
  # Delete sql data...
  Nunes.untraced do
    User.delete_all
    Nunes::Property.delete_all
    Nunes::Event.delete_all
    Nunes::Span.delete_all
  end

  # Reset otel...
  OpenTelemetry::TestHelpers.reset_opentelemetry

  # Reset some nunes state...
  Nunes.unsubscribe
  Nunes.exporter.reset if Nunes.exporter.respond_to?(:reset)

  # Let's make sure we can print out errors so we know about them...
  Nunes.configure do |c|
    c.error_handler = ->(exception:, message:) { puts "#{exception} #{message}" }
  end
end
