# frozen_string_literal: true

require "helper"

module Nunes
  class RequestsControllerTest < ActionDispatch::IntegrationTest
    test "renders requests index and show" do
      freeze_time do
        get "/users"
        assert_response :success

        span = Span.requests.first!
        assert_not_nil span
        assert_equal span.name, "GET /users"
        assert_equal "GET", span.property("http.method")
        assert_equal "/users", span.property("http.target")
        assert_equal 200, span.property("http.status_code")

        # Shows up on dashboard too.
        get "/nunes"
        assert_response :success
        assert_select ".request-verb", "GET"
        assert_select ".request-path", "/users"
        assert_select ".request-status", "200"
        assert_select ".request-when", "1m ago"

        get "/nunes/requests/#{span.trace_id}"
        assert_response :success
      end
    end

    test "renders 404 when viewing a request that doesn't exist" do
      get "/nunes/requests/123"
      assert_response :not_found
    end
  end
end
