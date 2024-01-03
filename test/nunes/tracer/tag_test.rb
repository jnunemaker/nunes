# frozen_string_literal: true

require 'helper'
require 'nunes/tracer/tag'

module Nunes
  class Tracer
    class TagTest < Nunes::Test
      def test_from_hash_returns_array_of_tags_when_hash_is_nil
        result = Tag.from_hash(nil)
        assert_equal [], result
      end

      def test_from_hash_returns_array_of_tags_when_hash_is_empty
        result = Tag.from_hash({})
        assert_equal [], result
      end

      def test_from_hash_returns_array_of_tags
        hash = { key1: 'value1', 'key2' => 'value2' }
        tags = Tag.from_hash(hash)

        assert_instance_of Array, tags
        assert_equal 2, tags.size

        assert_equal :key1, tags[0].key
        assert_equal 'value1', tags[0].value

        assert_equal :key2, tags[1].key
        assert_equal 'value2', tags[1].value
      end

      def test_tags_with_same_key_and_value_are_equal
        tag1 = Tag.new(:key, 'value')
        tag2 = Tag.new(:key, 'value')

        assert_equal tag1, tag2
      end

      def test_tags_with_different_key_are_not_equal
        tag1 = Tag.new(:key1, 'value')
        tag2 = Tag.new(:key2, 'value')

        refute_equal tag1, tag2
      end

      def test_tags_with_different_value_are_not_equal
        tag1 = Tag.new(:key, 'value1')
        tag2 = Tag.new(:key, 'value2')

        refute_equal tag1, tag2
      end
    end
  end
end
