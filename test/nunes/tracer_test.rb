# frozen_string_literal: true

require 'helper'
require 'nunes/tracer'

module Nunes
  class TracerTest < ActiveSupport::TestCase
    def test_trace
      executed = false
      yielded_span = nil
      tracer = Tracer.new
      result = tracer.trace('request', tags: { verb: 'GET' }) do |span|
        executed = true
        yielded_span = span

        tracer.trace('middleware') {}

        tracer.trace('process action') {}
        tracer.trace('model') do
          tracer.trace('sql') {}
        end

        'result'
      end
      assert executed
      assert_equal 'result', result

      assert root = tracer.adapter.all.first
      assert_equal yielded_span, root
      assert_equal 'GET', root[:verb]
      assert_equal 5, tracer.adapter.get(root.trace_id).size

      assert_nil tracer.active_span
      assert_nil tracer.trace_id
    end

    def test_trace_with_exception
      yielded_span = nil
      tracer = Tracer.new

      assert_raises RuntimeError do
        tracer.trace('request', tags: { verb: 'GET' }) do |span|
          yielded_span = span
          tracer.trace('middleware') { raise }
        end
      end

      assert root = tracer.adapter.all.first
      assert_equal yielded_span, root
      assert_equal 'GET', root[:verb]

      assert_nil tracer.active_span
      assert_nil tracer.trace_id
    end
  end
end
