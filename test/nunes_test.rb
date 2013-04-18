require "helper"

class NunesTest < ActiveSupport::TestCase
  test "subscribe" do
    begin
      subscribers = Nunes.subscribe(adapter)
      assert_instance_of Array, subscribers

      subscribers.each do |subscriber|
        assert_instance_of \
          ActiveSupport::Notifications::Fanout::Subscriber,
          subscriber
      end
    ensure
      Array(subscribers).each do |subscriber|
        ActiveSupport::Notifications.unsubscribe(subscriber)
      end
    end
  end
end
