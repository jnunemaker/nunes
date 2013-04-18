require "helper"
require "minitest/mock"

class DefaultAdapterTest < ActiveSupport::TestCase
  test "passes increment along" do
    mock = MiniTest::Mock.new
    mock.expect :increment, nil, ["single", 1]
    mock.expect :increment, nil, ["double", 2]

    client = Nunes::Adapters::Default.new(mock)
    client.increment("single")
    client.increment("double", 2)

    mock.verify
  end

  test "passes timing along" do
    mock = MiniTest::Mock.new
    mock.expect :timing, nil, ["foo", 23]

    client = Nunes::Adapters::Default.new(mock)
    client.timing("foo", 23)

    mock.verify
  end
end
