module Nunes
  module SharedAdapterTests
    def test_get_when_trace_not_found
      assert_nil @adapter.get("non_existent_request_id")
    end

    def test_save_and_get
      span = Nunes::Tracer::Span.new(name: "request", tags: {id: "1"}).time { |s| s }
      @adapter.save("1", span)
      assert_equal span, @adapter.get("1")

      span = Nunes::Tracer::Span.new(name: "request", tags: {id: "2"}).time { |s| s }
      @adapter.save("2", span)
      assert_equal span, @adapter.get("2")
    end

    def test_all_when_no_traces
      assert_equal([], @adapter.all)
    end

    def test_all
      span1 = Nunes::Tracer::Span.new(name: "1", tags: {id: "2"}).time { |s| s }
      span2 = Nunes::Tracer::Span.new(name: "2", tags: {id: "2"}).time { |s| s }
      @adapter.save("1", span1)
      @adapter.save("2", span2)

      assert_equal([span2, span1], @adapter.all)
    end
  end
end
