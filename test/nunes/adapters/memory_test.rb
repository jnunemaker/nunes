# frozen_string_literal: true

require "helper"
require "nunes/adapters/memory"
require "nunes/shared_adapter_tests"

class NunesAdaptersMemoryTest < Nunes::Test
  prepend Nunes::SharedAdapterTests

  def setup
    @adapter = Nunes::Adapters::Memory.new
  end
end
