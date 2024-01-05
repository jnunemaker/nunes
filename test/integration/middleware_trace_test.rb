require 'helper'
require 'nunes/adapters/active_record'

module Nunes
  class MiddlewareTraceTest < ActionDispatch::IntegrationTest
    test 'traces rails requests' do
      freeze_time do
        get '/users',
            headers: { 'HTTP_X_REQUEST_ID' => '123' },
            env: { 'REMOTE_ADDR' => '123.123.123.123' }

        assert_response :success

        span = Nunes.adapter.all.first
        refute_nil span
        assert_equal span.name, 'request'
        assert_equal 'GET', span[:verb]
        assert_equal '/users', span[:path]
        assert_equal '200', span[:status]
        assert_equal '123.123.123.123', span[:ip]
        assert_equal Time.now.to_i.to_s, span[:started_at]
      end
    end

    test 'traces rails controller actions' do
      freeze_time do
        get '/users',
            headers: { 'HTTP_X_REQUEST_ID' => '123' },
            env: { 'REMOTE_ADDR' => '123.123.123.123' }

        assert_response :success

        refute_nil root = Nunes.adapter.all.first
        spans = Nunes.adapter.get(root.trace_id)
        span = spans.detect { |s| s.name == 'process_action.action_controller' }
        refute_nil span
        assert_equal 'UsersController', span[:controller]
        assert_equal 'index', span[:action]
        assert_equal 'html', span[:format]
        assert_equal 'GET', span[:verb]
        assert_equal '/users', span[:path]
      end
    end

    test 'traces rails active record sql' do
      freeze_time do
        get '/users',
            headers: { 'HTTP_X_REQUEST_ID' => '123' },
            env: { 'REMOTE_ADDR' => '123.123.123.123' }

        assert_response :success

        refute_nil root = Nunes.adapter.all.first
        spans = Nunes.adapter.get(root.trace_id)
        span = spans.detect { |s| s.name == 'sql.active_record' }
        refute_nil span
        refute_nil span[:event_id]
        assert_equal 'SELECT "users".* FROM "users"', span[:sql]
        assert_equal 'User Load', span[:name]
      end
    end

    test 'does not trace ignored requests' do
      get '/nunes'
      assert_equal 0, Nunes.adapter.all.size
    end
  end
end
