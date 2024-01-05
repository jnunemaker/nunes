require_relative 'adapters/null'
require_relative 'adapters/active_record'

module Nunes
  class Configuration
    def initialize
      @adapter = -> { Adapters::ActiveRecord.new }
    end

    def adapter(&block)
      if block_given?
        @tracer = nil
        @adapter = block
      else
        @adapter.call
      end
    end

    def tracer
      @tracer ||= Tracer.new(adapter:)
    end
  end
end
