module StatsdSocketTestHelpers
  extend ActiveSupport::Concern

  included do
    setup    { setup_socket }
    teardown { teardown_socket }
  end

  attr_reader :statsd_socket

  def setup_socket
    # statsd-ruby does this for tests, not a fan, but ok for now
    @statsd_socket = Thread.current[:statsd_socket] = FakeUdpSocket.new
  end

  def teardown_socket
    @statsd_socket = Thread.current[:statsd_socket] = nil
  end
end
