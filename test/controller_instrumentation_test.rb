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
    assert_timer "action_controller.runtime.db"
    assert_timer "action_controller.runtime.view"

    assert_timer "action_controller.controller.PostsController.index.runtime.total"
    assert_timer "action_controller.controller.PostsController.index.runtime.view"
    assert_timer "action_controller.controller.PostsController.index.runtime.db"
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

    refute_timer "action_controller.runtime.view"
    refute_timer "action_controller.controller.PostsController.some_redirect.runtime.view"
  end

  test "action with exception" do
    get :some_boom rescue StandardError # catch the boom

    assert_response :success

    assert_counter "action_controller.format.html"

    assert_timer "action_controller.runtime.total"
    assert_timer "action_controller.controller.PostsController.some_boom.runtime.total"

    refute_timer "action_controller.runtime.view"
    refute_timer "action_controller.controller.PostsController.some_boom.runtime.view"
  end

  test "with instrument format disabled" do
    begin
      original_format_enabled = Nunes::Subscribers::ActionController.instrument_format
      Nunes::Subscribers::ActionController.instrument_format = false

      get :index

      refute_counter "action_controller.format.html"
    ensure
      Nunes::Subscribers::ActionController.instrument_format = original_format_enabled
    end
  end

  test "with instrument db runtime disabled" do
    begin
      original_format_enabled = Nunes::Subscribers::ActionController.instrument_db_runtime
      Nunes::Subscribers::ActionController.instrument_db_runtime = false

      get :index

      refute_timer "action_controller.runtime.db"
      refute_timer "action_controller.controller.PostsController.index.runtime.db"
    ensure
      Nunes::Subscribers::ActionController.instrument_db_runtime = original_format_enabled
    end
  end

  test "with instrument view runtime disabled" do
    begin
      original_format_enabled = Nunes::Subscribers::ActionController.instrument_view_runtime
      Nunes::Subscribers::ActionController.instrument_view_runtime = false

      get :index

      refute_timer "action_controller.runtime.view"
      refute_timer "action_controller.controller.PostsController.index.runtime.view"
    ensure
      Nunes::Subscribers::ActionController.instrument_view_runtime = original_format_enabled
    end
  end
end
