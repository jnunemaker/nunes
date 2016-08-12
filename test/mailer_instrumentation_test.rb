require "helper"

class MailerInstrumentationTest < ActionMailer::TestCase
  include ActiveJob::TestHelper

  tests PostMailer

  setup :setup_subscriber
  teardown :teardown_subscriber

  def setup_subscriber
    @subscriber = Nunes::Subscribers::ActionMailer.subscribe(adapter)
  end

  def teardown_subscriber
    ActiveSupport::Notifications.unsubscribe @subscriber if @subscriber
  end

  test "deliver_now" do
    PostMailer.created.deliver_now
    assert_timer "action_mailer.deliver.PostMailer"
  end

  test "deliver_later" do
    perform_enqueued_jobs do
      PostMailer.created.deliver_later
    end
    assert_timer "action_mailer.deliver.PostMailer"
  end

  test "receive" do
    PostMailer.receive PostMailer.created
    assert_timer "action_mailer.receive.PostMailer"
  end
end
