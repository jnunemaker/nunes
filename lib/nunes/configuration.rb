require_relative "adapters/null"
require_relative "adapters/active_record"

module Nunes
  class Configuration
    def initialize
      @adapter = -> {
        Rails.env.production? ? Adapters::Null.new : Adapters::ActiveRecord.new
      }
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
