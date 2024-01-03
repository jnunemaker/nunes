# frozen_string_literal: true

require 'helper'
require 'nunes/adapters/memory'
require 'nunes/shared_adapter_tests'

module Nunes
  module Adapters
    class MemoryTest < Nunes::Test
      prepend Nunes::SharedAdapterTests

      def setup
        @adapter = Memory.new
      end
    end
  end
end
