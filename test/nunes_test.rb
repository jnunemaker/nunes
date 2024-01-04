# frozen_string_literal: true

require 'helper'

class NunesTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Nunes::VERSION
  end

  def test_configure
    Nunes.configure do |config|
      config.adapter { Nunes::Adapters::Memory.new }
    end

    assert_instance_of Nunes::Adapters::Memory, Nunes.adapter
  end

  def test_configuration_per_thread
    assert_instance_of Nunes::Configuration, Nunes.configuration
    thread = Thread.new { Nunes.configuration }.tap(&:join)
    refute_same Nunes.configuration, thread.value
  end

  def test_setting_configuration
    configuration = Nunes::Configuration.new
    Nunes.configuration = configuration
    assert_same configuration, Nunes.configuration
  end

  def test_now
    start = Nunes.now
    finish = Nunes.now
    assert start <= finish, "#{start} <= #{finish}"
    assert_instance_of Integer, start
    assert_instance_of Integer, finish
  end

  def test_reset
    Thread.current[:nunes_tracer_context] = 'blah'
    config = Nunes.configuration
    Nunes.reset
    refute_same config, Nunes.configuration
    assert_equal({ spans: [] }, Thread.current[:nunes_tracer_context])
  end

  def test_adapter
    assert_same Nunes.tracer.adapter, Nunes.adapter
  end

  def test_trace_delegates_to_tracer
    root = nil
    Nunes.trace('name') { |span| root = span }
    assert_instance_of Nunes::Tracer::Span, root
    assert_equal 'name', root.name
  end
end
