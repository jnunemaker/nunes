# frozen_string_literal: true

require "pathname"
require "forwardable"
require_relative "nunes/version"
require_relative "nunes/configuration"
require_relative "nunes/middleware"
require_relative "nunes/tracer"

module Nunes
  extend self
  class Error < StandardError; end

  extend Forwardable
  def_delegators :tracer, :adapter, :trace, :span

  def root
    @root ||= Pathname(__FILE__).dirname.join("..").expand_path
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

require "nunes/engine" if defined?(Rails)

require "universalid"
UniversalID::MessagePackFactory.register(
  type: Nunes::Tracer::Span,
  packer: ->(span, packer) do
    packer.write span.name
    packer.write span.tags
    packer.write span.spans
    packer.write span.started_at
    packer.write span.finished_at
  end,
  unpacker: ->(unpacker) do
    name = unpacker.read
    tags = unpacker.read
    spans = unpacker.read
    started_at = unpacker.read
    finished_at = unpacker.read

    span = Nunes::Tracer::Span.new(name: name)
    tags.each { |tag| span.tag(tag.key, tag.value) }
    span.instance_variable_set(:@started_at, started_at)
    span.instance_variable_set(:@finished_at, finished_at)
    span.instance_variable_set(:@spans, spans)
    span
  end
)

UniversalID::MessagePackFactory.register(
  type: Nunes::Tracer::Tag,
  packer: ->(tag, packer) do
    packer.write tag.key
    packer.write tag.value
  end,
  unpacker: ->(unpacker) do
    key = unpacker.read
    value = unpacker.read
    Nunes::Tracer::Tag.new(key, value)
  end
)
