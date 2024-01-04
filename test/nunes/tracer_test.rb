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

      assert trace = tracer.adapter.all.first
      assert_equal yielded_span, trace
      assert_equal 'GET', trace.tags.first.value
      assert_equal 5, tracer.adapter.get(trace.trace_id).size

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

      assert trace = tracer.adapter.all.first
      assert_equal yielded_span, trace
      assert_equal 'GET', trace.tags.first.value

      assert_nil tracer.active_span
      assert_nil tracer.trace_id
    end
  end
end
