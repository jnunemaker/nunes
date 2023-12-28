# frozen_string_literal: true

require_relative "nunes/version"
require_relative "nunes/tracer"

module Nunes
  class Error < StandardError; end

  module_function

  def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
  end

  def tracer
    Thread.current[:nunes_tracer] ||= Tracer.new
  end

  def reset
    Thread.current[:nunes_tracer] = nil
  end

  def trace(...)
    tracer.trace(...)
  end

  def span(...)
    tracer.span(...)
  end
end

require "nunes/engine" if defined?(Rails)
