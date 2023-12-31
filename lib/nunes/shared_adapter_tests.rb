module Nunes
  module SharedAdapterTests
    def test_get_when_trace_not_found
      assert_nil @adapter.get("non_existent_request_id")
    end

    def test_save_and_get
      tracer = Nunes::Tracer.new
      root = nil
      tracer.trace("request", tags: {id: "1"}) do |span|
        root = span
      end
      @adapter.save(root)
      assert_equal root, @adapter.get("1")
    end

    def test_save_and_get_nested
      tracer = Nunes::Tracer.new
      tracer_root = nil
      tracer.trace("request", tags: {id: "1"}) do |span|
        tracer_root = span
        span.span("action_controller.process_action", tags: {controller: "Users", action: "show"}) { |span|
          span.span("active_record.sql", tags: {model: "User", sql: "select * from users where id = 1"}) { |span|
            sleep rand(0.001..0.01)
            "User"
          }
          span.span("action_view.render", tags: {}) { |span|
            span.span("action_view.render_partial", tags: {path: "app/views/shared/_head.html.erb"}) { |span|
              "Partial"
            }
            "View"
          }
          "Action"
        }
      end
      @adapter.save(tracer_root)
      adapter_root = @adapter.get("1")
      assert_equal tracer_root, adapter_root
    end

    def test_all_when_no_traces
      assert_equal([], @adapter.all)
    end

    def test_all
      span1 = Nunes::Tracer::Span.new(name: "1", tags: {id: "2"}).time { |s| s }
      span2 = Nunes::Tracer::Span.new(name: "2", tags: {id: "2"}).time { |s| s }
      @adapter.save(span1)
      @adapter.save(span2)

      assert_equal([span2, span1], @adapter.all)
    end
  end
end
