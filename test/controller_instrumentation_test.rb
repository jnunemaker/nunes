require "helper"

class ControllerInstrumentationTest < ActionController::TestCase
  tests PostsController

  test "instruments processing time" do
    get :index
    assert_response :success
  end
end
