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

  test "perform_now" do
    p = Post.new(title: 'Testing')
    SpamDetectorJob.perform_now(p)

    assert_timer   "active_job.spam_detector_job.perform"
  end

  test "perform_later" do
    p = Post.create!(title: 'Testing')
    SpamDetectorJob.perform_later(p)

    assert_timer   "active_job.spam_detector_job.perform"
    assert_counter "active_job.spam_detector_job.enqueue"
  end

end
