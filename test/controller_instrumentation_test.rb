require "helper"

Railsd::Subscribers::ActionController.subscribe(Statsd.new)

class ControllerInstrumentationTest < ActionController::TestCase
  tests PostsController

  test "process_action instrumentation" do
    get :index
    assert_response :success

    assert statsd_socket.counter?("action_controller.status.200")
    assert statsd_socket.counter?("action_controller.format.html")

    assert statsd_socket.timer?("action_controller.runtime")
    assert statsd_socket.timer?("action_controller.view_runtime")

    assert statsd_socket.timer?("action_controller.posts.index.runtime")
    assert statsd_socket.timer?("action_controller.posts.index.view_runtime")
  end
end
