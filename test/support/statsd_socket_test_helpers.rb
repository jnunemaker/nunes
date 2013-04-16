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
end
