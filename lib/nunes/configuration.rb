require_relative "adapters/moneta"

module Nunes
  class Configuration
    def initialize
      @adapter = -> { Nunes::Adapters::Moneta.new }
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
