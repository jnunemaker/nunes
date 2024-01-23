# frozen_string_literal: true

require "opentelemetry/error"
require "opentelemetry/sdk/trace/export"

module Nunes
  class ActiveRecordExporter
    SUCCESS = OpenTelemetry::SDK::Trace::Export::SUCCESS
    FAILURE = OpenTelemetry::SDK::Trace::Export::FAILURE
    TIMEOUT = OpenTelemetry::SDK::Trace::Export::TIMEOUT

    def finished_spans
      Nunes.untraced do
        Nunes::Span.connection_pool.with_connection do
          Span.order(:id)
        end
      end
    end

    def export(span_datas, timeout: nil)
      Nunes.untraced do
        Nunes::Span.connection_pool.with_connection do
          span_datas.each do |span_data|
            create_span(span_data)
          end
        end
      end

      SUCCESS
    end

    def force_flush(timeout: nil)
      SUCCESS
    end

    def shutdown(timeout: nil)
      SUCCESS
    end

    private

    def create_span(span_data)
      span_record = Span.create!({
        name: span_data.name,
        kind: span_data.kind,
        span_id: span_data.hex_span_id,
        trace_id: span_data.hex_trace_id,
        parent_span_id: span_data.hex_parent_span_id,
        start_timestamp: span_data.start_timestamp,
        end_timestamp: span_data.end_timestamp,
        total_recorded_links: span_data.total_recorded_links,
        total_recorded_events: span_data.total_recorded_events,
        total_recorded_properties: span_data.total_recorded_attributes,
      })

      span_data.events&.each do |span_event|
        create_event(span_record, span_event)
      end

      create_properties(span_record, span_data)
    end

    def create_event(span_record, span_event)
      event_record = span_record.events.create!({
        name: span_event.name,
        created_at: span_event.timestamp,
      })
      create_properties(event_record, span_event)
    end

    def create_properties(record, span)
      span.attributes&.each do |key, value|
        record.properties.create!(key:, value:) if value.present?
      end
    end
  end
end
