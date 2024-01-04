# frozen_string_literal: true

require 'helper'
require 'nunes/adapters/memory'
require 'nunes/shared_adapter_tests'

module Nunes
  module Adapters
    class MemoryTest < ActiveSupport::TestCase
      prepend Nunes::SharedAdapterTests

      setup { @adapter = Memory.new }
    end
  end
end
