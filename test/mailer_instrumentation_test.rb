require "helper"

class MailerInstrumentationTest < ActionMailer::TestCase
  tests PostMailer

  setup :setup_subscriber
  teardown :teardown_subscriber

  def setup_subscriber
    @subscriber = Railsd::Subscribers::ActionMailer.subscribe(Statsd.new)
  end

  def teardown_subscriber
    ActiveSupport::Notifications.unsubscribe @subscriber if @subscriber
  end

  test "deliver" do
    PostMailer.created.deliver
    assert statsd_socket.timer?("action_mailer.deliver.post_mailer")
  end

  test "receive" do
    PostMailer.receive PostMailer.created
    assert statsd_socket.timer?("action_mailer.receive.post_mailer")
  end
end
