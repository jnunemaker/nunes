class FakeUdpSocket
  attr_reader :buffer

  TimingRegex = /\:\d+\|ms\Z/
  CounterRegex = /\:\d+\|c\Z/

  def initialize
    @buffer = []
  end

  def send(message, *rest)
    @buffer.push message
  end

  def recv
    @buffer.shift
  end

  def clear
    @buffer = []
  end

  def timer_metrics
    @buffer.grep(TimingRegex)
  end

  def timer_metric_names
    timer_metrics.map { |op| op.gsub(TimingRegex, '') }
  end

  def timer?(metric)
    timer_metric_names.include?(metric)
  end

  def counter_metrics
    @buffer.grep(CounterRegex)
  end

  def counter_metric_names
    counter_metrics.map { |op| op.gsub(CounterRegex, '') }
  end

  def counter?(metric)
    counter_metric_names.include?(metric)
  end

  def inspect
    "<FakeUdpSocket: #{@buffer.inspect}>"
  end
end
