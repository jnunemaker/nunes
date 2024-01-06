# frozen_string_literal: true

require 'pathname'
require 'forwardable'
require_relative 'nunes/version'
require_relative 'nunes/configuration'
require_relative 'nunes/middleware'
require_relative 'nunes/tracer'

module Nunes
  extend self
  class Error < StandardError; end

  extend Forwardable
  def_delegators :configuration, :tracer
  def_delegators :tracer, :adapter, :trace, :manual_trace

  def root
    @root ||= Pathname(__FILE__).dirname.join('..').expand_path
  end

  def configure
    yield configuration if block_given?
  end

  def configuration
    Thread.current[:nunes_config] ||= Configuration.new
  end

  def configuration=(configuration)
    Thread.current[:nunes_config] = configuration
  end

  def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
  end

  def reset
    Nunes::Tracer.reset
    self.configuration = Configuration.new
  end
end

require 'nunes/engine' if defined?(Rails)
