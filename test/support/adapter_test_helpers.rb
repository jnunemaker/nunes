module AdapterTestHelpers
  extend ActiveSupport::Concern

  included do
    setup :setup_memory_adapter
  end

  attr_reader :adapter

  def setup_memory_adapter
    @adapter = Nunes::Adapters::Memory.new
  end

  def assert_timer(metric)
    assert adapter.timer?(metric),
      "Expected the timer #{metric.inspect} to be included in #{adapter.timer_metric_names.inspect}, but it was not."
  end

  def assert_no_timer(metric)
    assert ! adapter.timer?(metric),
      "Expected the timer #{metric.inspect} to not be included in #{adapter.timer_metric_names.inspect}, but it was."
  end

  def assert_counter(metric)
    assert adapter.counter?(metric),
      "Expected the counter #{metric.inspect} to be included in #{adapter.counter_metric_names.inspect}, but it was not."
  end

  def assert_no_counter(metric)
    assert ! adapter.counter?(metric),
      "Expected the counter #{metric.inspect} to not be included in adapter.counter_metric_names.inspect}, but it was."
  end
end
