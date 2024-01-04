module Nunes
  module SharedAdapterTests
    def test_get_when_trace_not_found
      assert_nil @adapter.get('non_existent_trace_id')
    end

    def test_all_when_no_traces
      assert_equal([], @adapter.all)
    end

    def test_save_all_get
      tracer = Tracer.new(adapter: @adapter)

      assert_equal 0, @adapter.all.size
      result = tracer.trace('request', tags: { id: '1' }) do
        tracer.trace('action_controller.process_action', tags: { controller: 'Users', action: 'show' }) do
          tracer.trace('active_record.sql', tags: { model: 'User', sql: 'select * from users where id = 1' }) do
            'User'
          end
          tracer.trace('action_view.render', tags: {}) do
            tracer.trace('action_view.render_partial', tags: { path: 'app/views/shared/_head.html.erb' }) do
              'Partial'
            end
            'View'
          end
          'Action'
        end
      end

      assert_equal 'Action', result, @adapter.class.name
      assert_equal 1, @adapter.all.size, @adapter.class.name
      trace_id = @adapter.all.first.trace_id
      spans = @adapter.get(trace_id)
      assert_equal 5, spans.size, @adapter.class.name
    end
  end
end
