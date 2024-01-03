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
  def_delegators :tracer, :adapter, :trace

  def root
    @root ||= Pathname(__FILE__).dirname.join('..').expand_path
  end

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
    self.configuration = Configuration.new
    Thread.current[:nunes_tracer] = nil
  end
end

require 'nunes/engine' if defined?(Rails)
