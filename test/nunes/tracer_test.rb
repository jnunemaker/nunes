# frozen_string_literal: true

require "test_helper"
require "nunes/tracer"

class NunesTracerTest < Minitest::Test
  def test_trace_executes_block
    executed = false
    tracer = Nunes::Tracer.new
    tracer.trace("request") do
      executed = true
    end
    assert executed
  end

  def test_trace_returns_result_of_block
    tracer = Nunes::Tracer.new
    result = tracer.trace("request") do
      :result
    end
    assert_equal :result, result
  end

  def test_trace_cleans_up_root_span_after_block
    tracer = Nunes::Tracer.new
    tracer.trace("request") { }
    assert_raises Nunes::Tracer::MissingRootSpan do
      tracer.spans
    end
  end

  def test_trace_does_not_allow_nesting_other_trace_calls
    tracer = Nunes::Tracer.new
    tracer.trace("request") do
      assert_raises Nunes::Tracer::TraceAlreadyStarted do
        tracer.trace("request") {}
      end
    end
  end

  def test_trace_yields_root_span
    yielded_span = nil
    tracer = Nunes::Tracer.new
    tracer.trace("asdf") do |span|
      yielded_span = span
    end
    refute_nil yielded_span
    assert_equal "asdf", yielded_span.name
  end

  def test_span_errors_when_no_root_span
    tracer = Nunes::Tracer.new
    assert_raises Nunes::Tracer::MissingRootSpan do
      tracer.span("mysql") { }
    end
  end

  def test_spans_errors_when_no_root_span
    tracer = Nunes::Tracer.new
    assert_raises Nunes::Tracer::MissingRootSpan do
      tracer.spans
    end
  end

  def test_span_executes_block
    executed = false
    tracer = Nunes::Tracer.new
    tracer.trace("asdf") do
      tracer.span("mysql") do
        executed = true
      end
    end
    assert executed
  end

  def test_span_returns_result_of_block
    tracer = Nunes::Tracer.new
    result = tracer.trace("asdf") do
      tracer.span("mysql") do
        :result
      end
    end
    assert_equal :result, result
  end

  def test_span_yields_span
    yielded_span = nil
    tracer = Nunes::Tracer.new
    result = tracer.trace("asdf") do
      tracer.span("mysql") { |span| yielded_span = span }
    end
    assert_equal "mysql", yielded_span.name
  end

  def test_allows_nesting_spans
    root_span = nil
    tracer = Nunes::Tracer.new
    tracer.trace("some_web_request_id") do |span|
      root_span = span
      tracer.span("User.find") do
        tracer.span("ActiveRecord.find") do
          tracer.span("mysql.query") do
            # do the query
          end
        end
      end
    end

    refute_nil root_span
    assert_equal 1, root_span.spans.length
    assert_equal 1, root_span.spans[0].spans.length
    assert_equal 1, root_span.spans[0].spans[0].spans.length
  end

  def test_allows_tagging_spans
    root_span = nil
    tracer = Nunes::Tracer.new
    tracer.trace("some_web_request_id") do |span|
      root_span = span
      tracer.span("User.find", tags: {user_id: 1}) do

      end
    end

    refute_nil root_span
    assert_equal 1, root_span.spans.length
    assert_equal [Nunes::Tracer::Tag.new(:user_id, 1)], root_span.spans[0].tags
  end
end