# frozen_string_literal: true

require "test_helper"

class NunesTest < Minitest::Test
  def setup
    Nunes.reset
  end

  def test_that_it_has_a_version_number
    refute_nil ::Nunes::VERSION
  end

  def test_tracer_per_thread
    assert_instance_of Nunes::Tracer, Nunes.tracer
    thread = Thread.new { Nunes.tracer }.tap(&:join)
    refute_equal Nunes.tracer, thread.value
  end

  def test_reset
    tracer = Nunes.tracer
    Nunes.reset
    refute_equal tracer, Nunes.tracer
  end

  def test_trace_delegates_to_tracer
    root = nil
    Nunes.trace("request-id") { |span| root = span }
    assert_instance_of Nunes::Tracer::Span, root
    assert_equal "request-id", root.name
  end

  def test_span_delegates_to_tracer
    span = nil

    Nunes.trace("request-id") do |root|
      Nunes.span("child") { |child| span = child }
    end

    assert_instance_of Nunes::Tracer::Span, span
    assert_equal "child", span.name
  end
end
