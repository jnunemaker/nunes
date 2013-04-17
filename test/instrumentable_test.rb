require "helper"

class InstrumentationTest < ActiveSupport::TestCase
  attr_reader :thing_class

  setup :setup_class
  teardown :teardown_class

  def setup_class
    @thing_class = Class.new {
      extend Railsd::Instrumentable

      def self.name
        'Thing'
      end

      def yo(args = {})
        :dude
      end
    }
  end

  def teardown_class
    @thing_class = nil
  end

  test "adds methods when extended" do
    assert thing_class.respond_to?(:instrument_method_time)
  end

  test "attempting to instrument time for method twice" do
    thing_class.instrument_method_time :yo

    assert_raises(ArgumentError, "already instrumented yo for Thing") do
      thing_class.instrument_method_time :yo
    end
  end

  test "instrument_method_time" do
    thing_class.instrument_method_time :yo

    event = slurp_events { thing_class.new.yo(some: 'thing') }.last

    assert_not_nil event, "No events were found."
    assert_equal "thing.yo", event.payload[:metric]
    assert_equal [{some: "thing"}], event.payload[:arguments]
    assert_equal :dude, event.payload[:result]
    assert_in_delta 0, event.duration, 0.1
  end

  test "instrument_method_time with custom name in hash" do
    thing_class.instrument_method_time :yo, name: 'Thingy.yohoho'

    event = slurp_events { thing_class.new.yo(some: 'thing') }.last

    assert_not_nil event, "No events were found."
    assert_equal "thingy.yohoho", event.payload[:metric]
  end

  test "instrument_method_time with custom name as string" do
    thing_class.instrument_method_time :yo, 'Thingy.yohoho'

    event = slurp_events { thing_class.new.yo(some: 'thing') }.last

    assert_not_nil event, "No events were found."
    assert_equal "thingy.yohoho", event.payload[:metric]
  end

  test "instrument_method_time with custom payload" do
    thing_class.instrument_method_time :yo, payload: {pay: "loadin"}

    event = slurp_events { thing_class.new.yo(some: 'thing') }.last

    assert_not_nil event, "No events were found."
    assert_equal "loadin", event.payload[:pay]
  end

  def slurp_events(&block)
    events = []
    callback = lambda { |*args| events << ActiveSupport::Notifications::Event.new(*args) }
    ActiveSupport::Notifications.subscribed(callback, Railsd::Instrumentable::MethodTimeEventName, &block)
    events
  end
end
