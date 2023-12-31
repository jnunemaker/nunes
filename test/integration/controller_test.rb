require "helper"
require "nunes/adapters/active_record"

class WebRequestsTest < ActionDispatch::IntegrationTest
  test "traces rails requests" do
    get "/users"
    assert_response :success
    assert span = Nunes.adapter.all.first
    assert_equal span.name, "request"
  end
end
