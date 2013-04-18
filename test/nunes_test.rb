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

  test "to_adapter for statsd" do
    client_with_gauge_and_timing = Class.new do
      def increment(*args); end
      def gauge(*args); end
      def timing(*args); end
    end.new

    adapter = Nunes.to_adapter(client_with_gauge_and_timing)
    assert_instance_of Nunes::Adapters::Default, adapter
  end

  test "to_adapter for instrumental" do
    client_with_gauge_but_not_timing = Class.new do
      def increment(*args); end
      def gauge(*args); end
    end.new

    adapter = Nunes.to_adapter(client_with_gauge_but_not_timing)
    assert_instance_of Nunes::Adapters::TimingAliased, adapter
  end

  test "to_adapter for adapter" do
    memory = Nunes::Adapters::Memory.new
    adapter = Nunes.to_adapter(memory)
    assert_equal memory, adapter
  end

  test "to_adapter with hash" do
    hash = {}
    adapter = Nunes.to_adapter(hash)
    assert_instance_of Nunes::Adapters::Memory, adapter
  end

  test "to_adapter with nil" do
    assert_raises(ArgumentError) { Nunes.to_adapter(nil) }
  end
end
