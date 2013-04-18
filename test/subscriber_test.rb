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

      # minitest stub works with call, so i change it to just return self, since
      # all we really want to test in this instance is that things are wired
      # up right, not that call dispatches events correctly
      def call(*args)
        self
      end
    end
  end

  test "subscribe" do
    client = {}
    instance = subscriber_class.new(client)

    subscriber_class.stub :new, instance do
      mock = Minitest::Mock.new
      mock.expect :subscribe, :subscriber, [subscriber_class.pattern, instance]

      assert_equal :subscriber, subscriber_class.subscribe(adapter, mock)

      mock.verify
    end
  end

  test "initialize" do
    adapter = Object.new
    Nunes.stub :to_adapter, adapter do
      instance = subscriber_class.new({})
      assert_equal adapter, instance.adapter
    end
  end
end
