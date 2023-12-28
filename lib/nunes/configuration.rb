require_relative "adapters/memory"

module Nunes
  class Configuration
    def initialize
      @adapter = -> { Nunes::Adapters::Memory.new }
    end

    def adapter(&block)
      if block_given?
        @adapter = block
      else
        @adapter.call
      end
    end
  end
end
