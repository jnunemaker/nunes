require "helper"

class FakeUdpSocketTest < ActiveSupport::TestCase
  test "timer boolean" do
    socket = FakeUdpSocket.new
    socket.send "action_controller.posts.index.runtime:2|ms"
    assert_equal true,  socket.timer?("action_controller.posts.index.runtime")
    assert_equal false, socket.timer?("action_controller.posts.index.faketime")
  end

  test "counter boolean" do
    socket = FakeUdpSocket.new
    socket.send "action_controller.status.200:1|c"
    assert_equal true,  socket.counter?("action_controller.status.200")
    assert_equal false, socket.counter?("action_controller.status.400")
  end

  test "send, recv and clear" do
    socket = FakeUdpSocket.new
    socket.send "foo"
    socket.send "bar"
    assert_equal "foo", socket.recv
    socket.clear
    assert_nil socket.recv
  end
end
