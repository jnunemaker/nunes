# frozen_string_literal: true

require 'helper'
require 'nunes/tracer'

module Nunes
  class ConfigurationTest < ActiveSupport::TestCase
    def test_adapter
      config = Configuration.new
      assert_instance_of Adapters::ActiveRecord, config.adapter
    end

    def test_adapter_with_block
      config = Configuration.new
      tracer = config.tracer
      config.adapter { Adapters::Memory.new }
      assert_instance_of Adapters::Memory, config.adapter
      refute_same tracer, config.tracer
    end

    def test_tracer
      config = Configuration.new
      config.adapter { Adapters::Memory.new }
      assert_instance_of Tracer, config.tracer
      assert_instance_of Adapters::Memory, config.tracer.adapter
    end
  end
end
