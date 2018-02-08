require "helper"

class NunesTest < ActiveSupport::TestCase
  test "subscribe" do
    begin
      subscribers = Nunes.subscribe(adapter)
      assert_instance_of Array, subscribers

      subscribers.each do |subscriber|
        assert_instance_of \
          ActiveSupport::Notifications::Fanout::Subscribers::Timed,
          subscriber
      end
    ensure
      Array(subscribers).each do |subscriber|
        ActiveSupport::Notifications.unsubscribe(subscriber)
      end
    end
  end

  test "class_to_metric" do
    assert_nil Nunes.class_to_metric(nil)
    assert_equal "Foo", Nunes.class_to_metric("Foo")
    assert_equal "Nunes", Nunes.class_to_metric(Nunes)
    assert_equal "Spam-DetectorJob", Nunes.class_to_metric(Spam::DetectorJob)
    assert_equal "Spam-DetectorJob", Nunes.class_to_metric("Spam::DetectorJob")
  end
end
