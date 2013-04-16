class FakeUdpSocket
  TimingRegex = /\:\d+\|ms\Z/

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

  def timer?(metric)
    timing_messages = @buffer.grep(TimingRegex)
    metric_names = timing_messages.map { |op| op.gsub(TimingRegex, '') }
    metric_names.include?(metric)
  end

  def counter?(metric, incr_by = 1)
    counter_message = "#{metric}:#{incr_by}|c"
    @buffer.include?(counter_message)
  end

  def inspect
    "<FakeUdpSocket: #{@buffer.inspect}>"
  end
end
