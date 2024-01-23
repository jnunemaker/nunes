# frozen_string_literal: true

require "helper"

module Nunes
  class PropertyTest < ActiveSupport::TestCase
    test "validates presence of key" do
      property = Property.new(key: nil)
      property.valid?
      assert_equal ["can't be blank"], property.errors[:key]
    end

    test "supports primitive values" do
      {
        "foo" => "string",
        1 => "integer",
        1.0 => "float",
        true => "boolean",
        false => "boolean",
      }.each do |value, type|
        owner = Span.create!({
          name: "someting",
          kind: "internal",
          span_id: OpenTelemetry::Trace.generate_span_id.unpack1("H*"),
          trace_id: OpenTelemetry::Trace.generate_trace_id.unpack1("H*"),
          start_timestamp: Process.clock_gettime(Process::CLOCK_REALTIME, :nanosecond),
          end_timestamp: Process.clock_gettime(Process::CLOCK_REALTIME, :nanosecond),
        })

        property = Property.create!(key: "something", value:, owner:)
        assert_equal type, property.value_type

        property.valid?

        assert_empty property.errors[:value], "value: #{value.inspect} should be valid"
        # should come back out of the database all good
        assert_equal value, Property.find(property.id).value
      end
    end

    test "supports arrays with all primitive values" do
      owner = Span.create!({
        name: "someting",
        kind: "internal",
        span_id: OpenTelemetry::Trace.generate_span_id.unpack1("H*"),
        trace_id: OpenTelemetry::Trace.generate_trace_id.unpack1("H*"),
        start_timestamp: Process.clock_gettime(Process::CLOCK_REALTIME, :nanosecond),
        end_timestamp: Process.clock_gettime(Process::CLOCK_REALTIME, :nanosecond),
      })

      value = ["1", 2, 3.0, true, false]
      property = Property.create!(value:, key: "something", owner:)
      assert_equal "array", property.value_type

      property.valid?

      assert_empty property.errors[:value]
      # should come back out of the database all good
      assert_equal value, Property.find(property.id).value
    end

    test "does not support arrays with non-primitive values" do
      property = Property.new(value: [{ foo: "bar" }])
      property.valid?
      assert_equal ["must be primitive (boolean, float, integer, and string) or array of primitives"],
                   property.errors[:value]
    end

    test "does not work with value that is an unsupported type" do
      property = Property.new(value: { foo: "bar" })
      property.valid?
      assert_equal ["must be primitive (boolean, float, integer, and string) or array of primitives"],
                   property.errors[:value]
    end
  end
end
