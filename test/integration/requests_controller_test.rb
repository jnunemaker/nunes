require 'helper'
require 'nunes/adapters/active_record'

module Nunes
  class RequestsControllerTest < ActionDispatch::IntegrationTest
    test 'traces rails requests' do
      freeze_time do
        get '/users'
        assert_response :success

        span = Nunes.adapter.all.first
        refute_nil span
        assert_equal span.name, 'request'
        assert_equal 'GET', span[:verb]
        assert_equal '/users', span[:path]
        assert_equal '200', span[:status]
        assert_equal Time.now.to_i.to_s, span[:started_at]

        # Shows up on dashboard too.
        get '/nunes'
        assert_response :success
        assert_select '.request-verb', 'GET'
        assert_select '.request-path', '/users'
        assert_select '.request-status', '200'
        assert_select '.request-when', '1m ago'

        get "/nunes/requests/#{span.trace_id}"
        assert_response :success
      end
    end
  end
end
