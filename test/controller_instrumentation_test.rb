require "helper"

class ControllerInstrumentationTest < ActionController::TestCase
  tests PostsController

  test "process_action" do
    get :index

    assert_response :success

    assert statsd_socket.counter?("action_controller.status.200")
    assert statsd_socket.counter?("action_controller.format.html")

    assert statsd_socket.timer?("action_controller.runtime")
    assert statsd_socket.timer?("action_controller.view_runtime")

    assert statsd_socket.timer?("action_controller.posts.index.runtime")
    assert statsd_socket.timer?("action_controller.posts.index.view_runtime")
  end

  test "send_data" do
    get :some_data

    assert_response :success

    assert statsd_socket.counter?("action_controller.status.200")

    assert statsd_socket.timer?("action_controller.runtime")
    assert statsd_socket.timer?("action_controller.view_runtime")

    assert statsd_socket.timer?("action_controller.posts.some_data.runtime")
    assert statsd_socket.timer?("action_controller.posts.some_data.view_runtime")
  end

  test "send_file" do
    get :some_file

    assert_response :success

    assert statsd_socket.counter?("action_controller.status.200")

    assert statsd_socket.timer?("action_controller.runtime")
    assert statsd_socket.timer?("action_controller.posts.some_file.runtime")

    assert ! statsd_socket.timer?("action_controller.view_runtime")
    assert ! statsd_socket.timer?("action_controller.posts.some_file.view_runtime")
  end

  test "redirect_to" do
    get :some_redirect

    assert_response :redirect

    assert statsd_socket.counter?("action_controller.status.302")

    assert statsd_socket.timer?("action_controller.runtime")
    assert statsd_socket.timer?("action_controller.posts.some_redirect.runtime")

    assert ! statsd_socket.timer?("action_controller.view_runtime")
    assert ! statsd_socket.timer?("action_controller.posts.some_redirect.view_runtime")
  end

  test "action with exception" do
    get :some_boom rescue StandardError # catch the boom

    assert_response :success

    assert statsd_socket.counter?("action_controller.exception.RuntimeError")
    assert statsd_socket.counter?("action_controller.format.html")

    assert statsd_socket.timer?("action_controller.runtime")
    assert statsd_socket.timer?("action_controller.posts.some_boom.runtime")

    assert ! statsd_socket.timer?("action_controller.view_runtime")
    assert ! statsd_socket.timer?("action_controller.posts.some_boom.view_runtime")
  end
end
