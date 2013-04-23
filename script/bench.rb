require "benchmark"
require "securerandom"
require "active_support/notifications"
require "bundler"
Bundler.setup :default, :bench

require_relative "../lib/nunes"

adapter = Nunes::Adapter.wrap({})
Nunes::Subscribers::ActionController.subscribe(adapter)

require "rblineprof"
$profile = lineprof(/./) do
  puts Benchmark.realtime {
    1_000.times do
      ActiveSupport::Notifications.instrument("process_action.action_controller")
    end
  }
end

def show_file(file)
  file = File.expand_path(file)
  File.readlines(file).each_with_index do |line, num|
    wall, cpu, calls = $profile[file][num+1]
    if calls && calls > 0
      printf "% 8.1fms + % 8.1fms (% 5d) | %s", cpu/1000.0, (wall-cpu)/1000.0, calls, line
      # printf "% 8.1fms (% 5d) | %s", wall/1000.0, calls, line
    else
      printf "                                | %s", line
      # printf "                   | %s", line
    end
  end
end

puts
$profile.each do |file, data|
  total, child, exclusive = data[0]
  puts file
  printf "  % 10.1fms in this file\n", exclusive/1000.0
  printf "  % 10.1fms in this file + children\n", total/1000.0
  printf "  % 10.1fms in children\n", child/1000.0

  if file =~ /nunes\/lib/
    show_file(file)
  end

  puts
end
