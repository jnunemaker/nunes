require "helper"

class RailsdTest < ActiveSupport::TestCase
  test "subscribe" do
    begin
      subscribers = Railsd.subscribe(Statsd.new)
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

  test "to_adapter" do
    client_with_gauge_and_timing = Class.new do
      def increment(*args); end
      def gauge(*args); end
      def timing(*args); end
    end.new

    adapter = Railsd.to_adapter(client_with_gauge_and_timing)
    assert_instance_of Railsd::Adapters::Statsd, adapter
  end

  test "to_adapter for instrumental" do
    client_with_gauge_but_not_timing = Class.new do
      def increment(*args); end
      def gauge(*args); end
    end.new

    adapter = Railsd.to_adapter(client_with_gauge_but_not_timing)
    assert_instance_of Railsd::Adapters::Instrumental, adapter
  end
end
