require "helper"

class NamespacedMailerInstrumentationTest < ActionMailer::TestCase
  tests Admin::PostMailer

  setup :setup_subscriber
  teardown :teardown_subscriber

  def setup_subscriber
    @subscriber = Nunes::Subscribers::ActionMailer.subscribe(adapter)
  end

  def teardown_subscriber
    ActiveSupport::Notifications.unsubscribe @subscriber if @subscriber
  end

  test "deliver_now" do
    Admin::PostMailer.created.deliver_now
    assert_timer "action_mailer.deliver.Admin-PostMailer"
  end

  test "deliver_later" do
    Admin::PostMailer.created.deliver_later
    assert_timer "action_mailer.deliver.Admin-PostMailer"
  end

  test "receive" do
    Admin::PostMailer.receive Admin::PostMailer.created
    assert_timer "action_mailer.receive.Admin-PostMailer"
  end
end
