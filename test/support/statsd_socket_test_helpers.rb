module StatsdSocketTestHelpers
  extend ActiveSupport::Concern

  included do
    setup :setup_statsd_socket
    teardown :teardown_statsd_socket
  end

  attr_reader :statsd_socket

  def setup_statsd_socket
    # statsd-ruby does this for tests, not a fan, but ok for now
    @statsd_socket = Thread.current[:statsd_socket] = FakeUdpSocket.new
  end

  def teardown_statsd_socket
    @statsd_socket = Thread.current[:statsd_socket] = nil
  end

  def assert_timer(metric)
    assert statsd_socket.timer?(metric),
      "Expected the timer #{metric.inspect} to be included in #{statsd_socket.timer_metric_names.inspect}, but it was not."
  end

  def assert_counter(metric)
    assert statsd_socket.counter?(metric),
      "Expected the counter #{metric.inspect} to be included in #{statsd_socket.counter_metric_names.inspect}, but it was not."
  end
end
