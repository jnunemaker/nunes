# frozen_string_literal: true

require_relative "nunes/version"
require_relative "nunes/span_processor"
require_relative "nunes/active_record_exporter"

require "opentelemetry/sdk"
require "opentelemetry-instrumentation-rails"
require "opentelemetry-instrumentation-mysql2"
require "opentelemetry-instrumentation-net_http"
require "opentelemetry-instrumentation-pg"
require "opentelemetry-instrumentation-rack"

module Nunes
  extend self

  class Error < StandardError; end

  def exporter
    @exporter ||= ActiveRecordExporter.new
  end

  def exporter=(exporter)
    @exporter = exporter
  end

  def span_processor
    @span_processor ||= SpanProcessor.new(exporter)
  end

  def tracer
    @tracer ||= OpenTelemetry.tracer_provider.tracer("Nunes", Nunes::VERSION)
  end

  def untraced(&block)
    OpenTelemetry::Common::Utilities.untraced(&block)
  end

  ACTIVE_SUPPORT_EVENTS = [
    "send_file.action_controller",
    "send_data.action_controller",
    "halted_callback.action_controller",
    "unpermitted_parameters.action_controller",
    "start_processing.action_controller",
    # "process_action.action_controller", # handled by otel action pack
    "write_fragment.action_controller",
    "read_fragment.action_controller",
    "expire_fragment.action_controller",
    "exist_fragment?.action_controller",
    # "process_middleware.action_dispatch",
    "redirect.action_dispatch",
    # "request.action_dispatch",
    # "render_template.action_view", # handled by otel action view
    # "render_partial.action_view", # handled by otel action view
    # "render_collection.action_view", # handled by otel action view
    # "render_layout.action_view", # handled by otel action view
    "sql.active_record",
    "strict_loading_violation.active_record",
    "instantiation.active_record",
    "deliver.action_mailer",
    "process.action_mailer",
    "cache_read.active_support",
    "cache_read_multi.active_support",
    "cache_generate.active_support",
    "cache_fetch_hit.active_support",
    "cache_write.active_support",
    "cache_write_multi.active_support",
    "cache_increment.active_support",
    "cache_decrement.active_support",
    "cache_delete.active_support",
    "cache_delete_multi.active_support",
    "cache_delete_matched.active_support",
    "cache_cleanup.active_support",
    "cache_prune.active_support",
    "cache_exist?.active_support",
    # "message_serializer_fallback.active_support",
    # "enqueue_at.active_job", # handled by otel active job
    # "enqueue.active_job", # handled by otel active job
    # "enqueue_retry.active_job", # handled by otel active job
    # "enqueue_all.active_job",
    "perform_start.active_job",
    # "perform.active_job", # handled by otel active job
    # "retry_stopped.active_job", # handled by otel active job
    # "discard.active_job", # handled by otel active job
    "perform_action.action_cable",
    "transmit.action_cable",
    "transmit_subscription_confirmation.action_cable",
    "transmit_subscription_rejection.action_cable",
    "broadcast.action_cable",
    "preview.active_storage",
    "transform.active_storage",
    "analyze.active_storage",
    "service_upload.active_storage",
    "service_streaming_download.active_storage",
    "service_download_chunk.active_storage",
    "service_download.active_storage",
    "service_delete.active_storage",
    "service_delete_prefixed.active_storage",
    "service_exist.active_storage",
    "service_url.active_storage",
    "service_update_metadata.active_storage",
    "process.action_mailbox",
  ].freeze

  def configure
    ENV["OTEL_SERVICE_NAME"] ||= Rails.application.class.name.split("::").first.underscore

    OpenTelemetry::SDK.configure do |c|
      yield c if block_given?
      c.logger = ::Rails.logger
      c.service_name = ENV["OTEL_SERVICE_NAME"]
      c.add_span_processor Nunes.span_processor
      c.use_all
    end

    ACTIVE_SUPPORT_EVENTS.each do |event_name|
      subscribers << OpenTelemetry::Instrumentation::ActiveSupport.subscribe(tracer, event_name)
    end
  end

  def subscribers
    @subscribers ||= []
  end

  def unsubscribe
    subscribers.each do |subscriber|
      ActiveSupport::Notifications.unsubscribe(subscriber)
    end
    @subscribers = nil
  end
end

require "nunes/engine" if defined?(Rails)
