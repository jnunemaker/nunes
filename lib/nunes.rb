# frozen_string_literal: true

require "forwardable"
require_relative "nunes/version"
require_relative "nunes/configuration"
require_relative "nunes/tracer"

module Nunes
  extend self
  class Error < StandardError; end


  extend Forwardable
  def_delegators :tracer, :adapter, :trace, :span

  def configure
    yield configuration if block_given?
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configuration=(configuration)
    @configuration = configuration
  end

  def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
  end

  def tracer
    Thread.current[:nunes_tracer] ||= Tracer.new(adapter: configuration.adapter)
  end

  def reset
    Thread.current[:nunes_tracer] = nil
  end
end

require "nunes/engine" if defined?(Rails)
