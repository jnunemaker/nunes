require "helper"

class JobInstrumentationTest < ActiveSupport::TestCase
  setup :setup_subscriber
  teardown :teardown_subscriber

  def setup_subscriber
    @subscriber = Nunes::Subscribers::ActiveJob.subscribe(adapter)
  end

  def teardown_subscriber
    ActiveSupport::Notifications.unsubscribe @subscriber if @subscriber
  end

  test "perform" do
    p = Post.new(title: 'Testing')
    SpamDetectorJob.new.perform(p)

    assert_timer "active_job.perform"
  end

end
