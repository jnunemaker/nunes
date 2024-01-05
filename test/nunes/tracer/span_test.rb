# frozen_string_literal: true

require 'helper'
require 'nunes/tracer/span'

module Nunes
  class Tracer
    class SpanTest < ActiveSupport::TestCase
      def test_initialize
        span = Tracer::Span.new(name: 'asdf')
        assert_equal 'asdf', span.name
        refute_nil span.id
        refute_nil span.trace_id
      end

      def test_initialize_full
        span = Tracer::Span.new(
          id: 'span-id',
          trace_id: 'trace-id',
          parent_id: 'parent-id',
          name: 'asdf',
          tags: { foo: 'bar' },
          started_at: 0,
          finished_at: 1
        )

        assert_equal 'span-id', span.id
        assert_equal 'trace-id', span.trace_id
        assert_equal 'parent-id', span.parent_id
        assert_equal 'asdf', span.name
        assert_equal 1, span.tags.length
        assert_equal 'bar', span[:foo]
        assert_equal 0, span.started_at
        assert_equal 1, span.finished_at
      end

      def test_duration
        assert_equal 23, Tracer::Span.new(
          name: 'asdf',
          started_at: 0,
          finished_at: 23
        ).duration
      end

      def test_duration_without_started_at
        assert_nil Tracer::Span.new(
          name: 'asdf',
          finished_at: 23
        ).duration
      end

      def test_duration_without_finished_at
        assert_nil Tracer::Span.new(
          name: 'asdf',
          started_at: 23
        ).duration
      end

      def test_time
        span = Tracer::Span.new(name: 'asdf')
        assert_nil span.started_at
        assert_nil span.finished_at
        result = span.time { 'something' }
        assert_equal 'something', result
        assert_instance_of Integer, span.started_at
        assert_instance_of Integer, span.finished_at
      end

      def test_time_with_block_that_raises
        span = Tracer::Span.new(name: 'asdf')
        assert_nil span.started_at
        assert_nil span.finished_at
        result = nil
        assert_raises StandardError do
          result = span.time { raise }
        end
        assert_nil result
        assert_instance_of Integer, span.started_at
        assert_instance_of Integer, span.finished_at
        assert_equal 'RuntimeError', span[:error]
      end

      def test_time_yields_span
        yielded_span = nil
        span = Tracer::Span.new(name: 'mysql')
        span.time { |s| yielded_span = s }
        assert_equal span, yielded_span
      end

      def test_tag
        span = Tracer::Span.new(name: 'asdf')
        span.tag :user_id, 5
        assert_equal 1, span.tags.length
        assert_equal '5', span[:user_id]
      end
    end
  end
end
