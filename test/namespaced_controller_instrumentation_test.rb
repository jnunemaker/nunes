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

    assert_counter "action_controller.status.200"
    assert_counter "action_controller.format.html"

    assert_timer "action_controller.runtime"
    assert_timer "action_controller.view_runtime"

    assert_timer "action_controller.admin.posts.index.runtime"
    assert_timer "action_controller.admin.posts.index.view_runtime"
  end
end
