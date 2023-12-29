# frozen_string_literal: true

require "helper"
require "nunes/adapters/memory"

class NunesAdaptersMemoryTest < Minitest::Test
  def setup
    @adapter = Nunes::Adapters::Memory.new
  end

  def test_index_when_no_traces
    assert_equal [], @adapter.index
  end

  def test_get_when_trace_not_found
    assert_nil @adapter.get("non_existent_request_id")
  end

  def test_save_get_and_index
    span = Nunes::Tracer::Span.new(name: "1")
    @adapter.save("1", span)
    assert_equal ["1"], @adapter.index
    assert_equal span, @adapter.get("1")

    span = Nunes::Tracer::Span.new(name: "2")
    @adapter.save("2", span)
    assert_equal ["2", "1"], @adapter.index
    assert_equal span, @adapter.get("2")
  end

  def test_get_multi_when_no_traces
    assert_equal({}, @adapter.get_multi([]))
  end

  def test_get_multi_for_non_existent_request_ids
    expected = {"non_existent_request_id" => nil}
    assert_equal expected, @adapter.get_multi("non_existent_request_id")
    assert_equal expected, @adapter.get_multi(["non_existent_request_id"])
  end

  def test_get_multi
    span1 = Nunes::Tracer::Span.new(name: "1")
    span2 = Nunes::Tracer::Span.new(name: "2")
    @adapter.save("1", span1)
    @adapter.save("2", span2)

    assert_equal({"1" => span1, "2" => span2}, @adapter.get_multi(["1", "2"]))
  end
end
