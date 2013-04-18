require "helper"

class AdapterTest < ActiveSupport::TestCase
  test "wrap for statsd" do
    client_with_gauge_and_timing = Class.new do
      def increment(*args); end
      def gauge(*args); end
      def timing(*args); end
    end.new

    adapter = Nunes::Adapter.wrap(client_with_gauge_and_timing)
    assert_instance_of Nunes::Adapters::Default, adapter
  end

  test "wrap for instrumental" do
    client_with_gauge_but_not_timing = Class.new do
      def increment(*args); end
      def gauge(*args); end
    end.new

    adapter = Nunes::Adapter.wrap(client_with_gauge_but_not_timing)
    assert_instance_of Nunes::Adapters::TimingAliased, adapter
  end

  test "wrap for adapter" do
    memory = Nunes::Adapters::Memory.new
    adapter = Nunes::Adapter.wrap(memory)
    assert_equal memory, adapter
  end

  test "wrap with hash" do
    hash = {}
    adapter = Nunes::Adapter.wrap(hash)
    assert_instance_of Nunes::Adapters::Memory, adapter
  end

  test "wrap with nil" do
    assert_raises(ArgumentError) { Nunes::Adapter.wrap(nil) }
  end
end
