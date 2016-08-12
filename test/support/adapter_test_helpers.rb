module AdapterTestHelpers
  extend ActiveSupport::Concern

  included do
    setup :setup_memory_adapter, :setup_data
    teardown :clean_data
  end

  attr_reader :adapter

  def setup_memory_adapter
    @adapter = Nunes::Adapters::Memory.new
  end

  def setup_data
    Post.create(:title => "First")
    Post.create(:title => "Second")
  end

  def clean_data
    Post.delete_all
  end

  def assert_timer(metric)
    assert adapter.timer?(metric),
      "Expected the timer #{metric.inspect} to be included in #{adapter.timer_metric_names.inspect}, but it was not."
  end

  def refute_timer(metric)
    assert ! adapter.timer?(metric),
      "Expected the timer #{metric.inspect} to not be included in #{adapter.timer_metric_names.inspect}, but it was."
  end

  def assert_counter(metric)
    assert adapter.counter?(metric),
      "Expected the counter #{metric.inspect} to be included in #{adapter.counter_metric_names.inspect}, but it was not."
  end

  def refute_counter(metric)
    refute adapter.counter?(metric),
      "Expected the counter #{metric.inspect} to not be included in #{adapter.counter_metric_names.inspect}, but it was."
  end

  def assert_no_counter(metric)
    assert ! adapter.counter?(metric),
      "Expected the counter #{metric.inspect} to not be included in adapter.counter_metric_names.inspect}, but it was."
  end
end
