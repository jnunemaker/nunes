require "helper"

class NamespacedControllerInstrumentationTest < ActionController::TestCase
  tests Admin::PostsController

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

    assert_timer "action_controller.controller.Admin.PostsController.index.runtime.total"
    assert_timer "action_controller.controller.Admin.PostsController.index.runtime.view"
    assert_timer "action_controller.controller.Admin.PostsController.index.runtime.db"

    assert_counter "action_controller.format.html"
    assert_counter "action_controller.status.200"

    assert_counter "action_controller.controller.Admin.PostsController.index.format.html"
    assert_counter "action_controller.controller.Admin.PostsController.index.status.200"
  end

  test "process_action w/ json" do
    get :index, format: :json

    assert_counter "action_controller.controller.Admin.PostsController.index.format.json"
  end

  test "process_action bad_request" do
    get :new

    assert_response :forbidden

    assert_counter "action_controller.controller.Admin.PostsController.new.status.403"
  end
end
