# frozen_string_literal: true

require "helper"
require "nunes/tracer/span"

class NunesTracerSpanTest < Minitest::Test
  def test_span_sets_name
    trace = Nunes::Tracer::Span.new(name: "asdf")
    trace.span("mysql") { }
    span = trace.spans[0]
    refute_nil span
    assert_equal "mysql", span.name
  end

  def test_span_sets_parent
    trace = Nunes::Tracer::Span.new(name: "asdf")
    trace.span("mysql") { }
    span = trace.spans[0]
    refute_nil span
    assert_equal trace, span.parent
  end

  def test_span_times_block
    trace = Nunes::Tracer::Span.new(name: "asdf")
    trace.span("mysql") { }
    span = trace.spans[0]
    refute_nil span
    assert_instance_of Integer, span.started_at
    assert_instance_of Integer, span.finished_at
    assert_instance_of Integer, span.duration
  end

  def test_span_can_have_children_spans
    span = Nunes::Tracer::Span.new(name: "asdf")
    span.span("asdf child 1") { }
    span.span("asdf child 2") { }
    assert_equal 2, span.spans.length
    assert_equal ["asdf child 1", "asdf child 2"], span.spans.map(&:name)
  end

  def test_span_returns_result_of_block
    span = Nunes::Tracer::Span.new(name: "asdf")
    result = span.span("asdf child 1") { :result }
    assert_equal :result, result
  end

  def test_can_have_many_nested_spans
    span = Nunes::Tracer::Span.new(name: "asdf")
    result = span.span("1") {
      span.span("2") {
        span.span("3") {
          :result
        }
      }
    }
    assert_equal :result, result
    assert_equal "1", span.spans[0].name
    assert_equal "2", span.spans[0].spans[0].name
    assert_equal "3", span.spans[0].spans[0].spans[0].name
  end

  def test_can_tag_error
    yielded_span = nil
    span = Nunes::Tracer::Span.new(name: "asdf")
    span.span("1") { |span|
      yielded_span = span
      begin
        raise
      rescue
        span.error
      end
    }
    assert_equal 1, yielded_span.tags.length
    assert_equal :error, yielded_span.tags[0].key
  end

  def test_time
    span = Nunes::Tracer::Span.new(name: "asdf")
    assert_nil span.started_at
    assert_nil span.finished_at
    result = span.time { "something" }
    assert_equal "something", result
    assert_instance_of Integer, span.started_at
    assert_instance_of Integer, span.finished_at
  end

  def test_time_with_block_that_raises
    span = Nunes::Tracer::Span.new(name: "asdf")
    assert_nil span.started_at
    assert_nil span.finished_at
    result = nil
    assert_raises StandardError do
      result = span.time { raise }
    end
    assert_nil result
    assert_instance_of Integer, span.started_at
    assert_instance_of Integer, span.finished_at
  end

  def test_time_yields_span
    yielded_span = nil
    span = Nunes::Tracer::Span.new(name: "mysql")
    span.time { |s| yielded_span = s }
    assert_equal span, yielded_span
  end

  def test_tag
    span = Nunes::Tracer::Span.new(name: "asdf")
    span.tag :user_id, 5
    assert_equal 1, span.tags.length
    assert_equal :user_id, span.tags[0].key
    assert_equal "5", span.tags[0].value
  end

  def test_error
    span = Nunes::Tracer::Span.new(name: "asdf")
    span.error
    assert_equal 1, span.tags.length
    assert_equal :error, span.tags[0].key
    assert_equal "true", span.tags[0].value
  end

  def test_descendants
    span = Nunes::Tracer::Span.new(name: "asdf")
    span.span("1") {
      span.span("2") {
        span.span("3") {
          span.span("4") {
            span.span("5") {
              span.span("6") {
                span.span("7") {
                  span.span("8") {
                    span.span("9") {
                      span.span("10") {

                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    assert_equal %w[1 2 3 4 5 6 7 8 9 10], span.descendants.map(&:name)
  end
end
