require "helper"
require "minitest/mock"

class InstrumentalAdapterTest < ActiveSupport::TestCase
  test "passes increment along" do
    mock = MiniTest::Mock.new
    mock.expect :increment, nil, ["single", 1]
    mock.expect :increment, nil, ["double", 2]

    client = Railsd::Adapters::Instrumental.new(mock)
    client.increment("single")
    client.increment("double", 2)

    mock.verify
  end

  test "sends timing to gauge" do
    mock = MiniTest::Mock.new
    mock.expect :gauge, nil, ["foo", 23]

    client = Railsd::Adapters::Instrumental.new(mock)
    client.timing("foo", 23)

    mock.verify
  end
end
