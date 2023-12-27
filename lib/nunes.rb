# frozen_string_literal: true

require_relative "nunes/version"

module Nunes
  class Error < StandardError; end

  module_function

  def now
    Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
  end
end
