require "helper"

class ControllerInstrumentationTest < ActionController::TestCase
  tests PostsController

  setup :setup_subscriber
  teardown :teardown_subscriber

  def setup_subscriber
    @subscriber = Railsd::Subscribers::ActionController.subscribe(adapter)
  end

  def teardown_subscriber
    ActiveSupport::Notifications.unsubscribe @subscriber if @subscriber
  end

  test "process_action" do
    get :index

    assert_response :success

    assert_counter "action_controller.status.200"
    assert_counter "action_controller.format.html"

    assert_timer "action_controller.runtime"
    assert_timer "action_controller.view_runtime"

    assert_timer "action_controller.posts.index.runtime"
    assert_timer "action_controller.posts.index.view_runtime"
  end

  test "send_data" do
    get :some_data

    assert_response :success

    assert_counter "action_controller.status.200"

    assert_timer "action_controller.runtime"
    assert_timer "action_controller.view_runtime"

    assert_timer "action_controller.posts.some_data.runtime"
    assert_timer "action_controller.posts.some_data.view_runtime"
  end

  test "send_file" do
    get :some_file

    assert_response :success

    assert_counter"action_controller.status.200"

    assert_timer "action_controller.runtime"
    assert_timer "action_controller.posts.some_file.runtime"

    assert ! adapter.timer?("action_controller.view_runtime")
    assert ! adapter.timer?("action_controller.posts.some_file.view_runtime")
  end

  test "redirect_to" do
    get :some_redirect

    assert_response :redirect

    assert_counter "action_controller.status.302"

    assert_timer "action_controller.runtime"
    assert_timer "action_controller.posts.some_redirect.runtime"

    assert_no_timer "action_controller.view_runtime"
    assert_no_timer "action_controller.posts.some_redirect.view_runtime"
  end

  test "action with exception" do
    get :some_boom rescue StandardError # catch the boom

    assert_response :success

    assert_counter "action_controller.exception.RuntimeError"
    assert_counter "action_controller.format.html"

    assert_timer "action_controller.runtime"
    assert_timer "action_controller.posts.some_boom.runtime"

    assert_no_timer "action_controller.view_runtime"
    assert_no_timer "action_controller.posts.some_boom.view_runtime"
  end
end
