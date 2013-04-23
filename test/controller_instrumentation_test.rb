require "helper"

class ControllerInstrumentationTest < ActionController::TestCase
  tests PostsController

  setup :setup_subscriber
  teardown :teardown_subscriber

  def setup_subscriber
    @subscriber = Nunes::Subscribers::ActionController.subscribe(adapter)
  end

  def teardown_subscriber
    ActiveSupport::Notifications.unsubscribe @subscriber if @subscriber
  end

  test "process_action" do
    get :index

    assert_response :success

    assert_counter "action_controller.status.200"
    assert_counter "action_controller.format.html"

    assert_timer "action_controller.runtime.total"
    assert_timer "action_controller.runtime.view"

    assert_timer "action_controller.controller.PostsController.index.runtime.total"
    assert_timer "action_controller.controller.PostsController.index.runtime.view"
  end

  test "send_data" do
    get :some_data

    assert_response :success

    assert_counter "action_controller.status.200"

    assert_timer "action_controller.runtime.total"
    assert_timer "action_controller.runtime.view"

    assert_timer "action_controller.controller.PostsController.some_data.runtime.total"
    assert_timer "action_controller.controller.PostsController.some_data.runtime.view"
  end

  test "send_file" do
    get :some_file

    assert_response :success

    assert_counter"action_controller.status.200"

    assert_timer "action_controller.runtime.total"
    assert_timer "action_controller.controller.PostsController.some_file.runtime.total"

    assert ! adapter.timer?("action_controller.runtime.view")
    assert ! adapter.timer?("action_controller.controller.PostsController.some_file.runtime.view")
  end

  test "redirect_to" do
    get :some_redirect

    assert_response :redirect

    assert_counter "action_controller.status.302"

    assert_timer "action_controller.runtime.total"
    assert_timer "action_controller.controller.PostsController.some_redirect.runtime.total"

    assert_no_timer "action_controller.runtime.view"
    assert_no_timer "action_controller.controller.PostsController.some_redirect.runtime.view"
  end

  test "action with exception" do
    get :some_boom rescue StandardError # catch the boom

    assert_response :success

    assert_counter "action_controller.exception.RuntimeError"
    assert_counter "action_controller.format.html"

    assert_timer "action_controller.runtime.total"
    assert_timer "action_controller.controller.PostsController.some_boom.runtime.total"

    assert_no_timer "action_controller.runtime.view"
    assert_no_timer "action_controller.controller.PostsController.some_boom.runtime.view"
  end
end
