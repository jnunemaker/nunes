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
    adapter = Railsd.to_adapter(Statsd.new)
    assert_instance_of Railsd::Adapters::Statsd, adapter
  end

  test "to_adapter for instrumental" do
    begin
      module ::Instrumental
        class Agent; end
      end

      adapter = Railsd.to_adapter(Instrumental::Agent.new)
      assert_instance_of Railsd::Adapters::Instrumental, adapter
    ensure
      Object.send :remove_const, :Instrumental
    end
  end
end
