require "helper"
require "minitest/mock"

class SubscriberTest < ActiveSupport::TestCase
  attr_reader :subscriber_class

  setup :setup_subscriber_class

  def setup_subscriber_class
    @subscriber_class = Class.new(Nunes::Subscriber) do
      def self.pattern
        /\.test\Z/
      end

      def foo(*args)
        increment "test.foo"
      end
    end
  end

  test "subscribe with adapter" do
    begin
      adapter = Nunes::Adapters::Memory.new
      subscriber = subscriber_class.subscribe(adapter)
      ActiveSupport::Notifications.instrument("foo.test")

      assert adapter.counter?("test.foo")
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end
  end

  test "subscribe with something that needs to be wrapped by adapter" do
    begin
      client = {}
      adapter = Nunes::Adapters::Memory.new
      subscriber = nil

      Nunes::Adapters::Memory.stub :new, adapter do
        subscriber = subscriber_class.subscribe(client)
        ActiveSupport::Notifications.instrument("foo.test")

        assert adapter.counter?("test.foo")
      end
    ensure
      ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
    end
  end
end
