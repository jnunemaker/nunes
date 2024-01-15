# frozen_string_literal: true

require "opentelemetry/error"
require "opentelemetry/sdk/trace/export"

module Nunes
  class SpanProcessor
    SUCCESS = OpenTelemetry::SDK::Trace::Export::SUCCESS
    FAILURE = OpenTelemetry::SDK::Trace::Export::FAILURE
    TIMEOUT = OpenTelemetry::SDK::Trace::Export::TIMEOUT

    def initialize(span_exporter)
      @span_exporter = span_exporter
    end

    def on_start(span, parent_context); end

    def on_finish(span)
      return unless span.context.trace_flags.sampled?

      @span_exporter&.export([span.to_span_data])
    rescue StandardError => e
      OpenTelemetry.handle_error(exception: e, message: "unexpected error in span.on_finish")
    end

    def force_flush(timeout: nil)
      @span_exporter.force_flush(timeout:) || SUCCESS
    end

    def shutdown(timeout: nil)
      @span_exporter&.shutdown(timeout:) || SUCCESS
    end
  end
end
