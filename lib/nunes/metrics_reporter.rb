module Nunes
  class MetricsReporter
    def add_to_counter(metric, increment: 1, labels: {})
      puts "add_to_counter: #{metric} #{increment} #{labels}"
    end

    def record_value(metric, value:, labels: {})
      puts "record_value: #{metric} #{value} #{labels}"
    end

    def observe_value(metric, value:, labels: {})
      puts "observe_value: #{metric} #{value} #{labels}"
    end
  end
end
