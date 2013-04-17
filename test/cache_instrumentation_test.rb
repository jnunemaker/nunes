require "helper"

class CacheInstrumentationTest < ActiveSupport::TestCase
  attr_reader :cache

  setup :setup_subscriber, :setup_cache
  teardown :teardown_subscriber, :teardown_cache

  def setup_subscriber
    @subscriber = Railsd::Subscribers::ActiveSupport.subscribe(Statsd.new)
  end

  def teardown_subscriber
    ActiveSupport::Notifications.unsubscribe @subscriber if @subscriber
  end

  def setup_cache
    ActiveSupport::Cache::MemoryStore.instrument = true
    @cache = ActiveSupport::Cache::MemoryStore.new
  end

  def teardown_cache
    ActiveSupport::Cache::MemoryStore.instrument = nil
    @cache = nil
  end

  test "cache_read miss" do
    cache.read('foo')

    assert statsd_socket.timer?("active_support.cache_read")
    assert statsd_socket.counter?("active_support.cache_miss")
  end

  test "cache_read hit" do
    cache.write('foo', 'bar')
    statsd_socket.clear
    cache.read('foo')

    assert statsd_socket.timer?("active_support.cache_read")
    assert statsd_socket.counter?("active_support.cache_hit")
  end

  test "cache_generate" do
    cache.fetch('foo') { |key| :generate_me_please }
    assert statsd_socket.timer?("active_support.cache_generate")
  end

  test "cache_fetch with hit" do
    cache.write('foo', 'bar')
    statsd_socket.clear
    cache.fetch('foo') { |key| :never_gets_here }

    assert statsd_socket.timer?("active_support.cache_fetch")
    assert statsd_socket.timer?("active_support.cache_fetch_hit")
  end

  test "cache_fetch with miss" do
    cache.fetch('foo') { 'foo value set here' }

    assert statsd_socket.timer?("active_support.cache_fetch")
    assert statsd_socket.timer?("active_support.cache_generate")
    assert statsd_socket.timer?("active_support.cache_write")
  end

  test "cache_write" do
    cache.write('foo', 'bar')
    assert statsd_socket.timer?("active_support.cache_write")
  end

  test "cache_delete" do
    cache.delete('foo')
    assert statsd_socket.timer?("active_support.cache_delete")
  end

  test "cache_exist?" do
    cache.exist?('foo')
    assert statsd_socket.timer?("active_support.cache_exist")
  end
end
