# frozen_string_literal: true

require 'erb'
require 'securerandom'
require_relative 'tracer'
require_relative 'event'

module Nunes
  # Middleware that adds tracing to all Rack requests.
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if ignore?(request)
        @app.call(env)
      else
        Nunes.trace(:request, tags: tags_from_request(request)) do |span|
          result = subscribe { @app.call(env) }
          status, _headers, _body = result
          span.tag :status, status
          result
        end
      end
    end

    private

    def subscribe(&block)
      ActiveSupport::Notifications.subscribed(method(:trace_event), /.*/, monotonic: true, &block)
    end

    def trace_event(name, start, finish, _id, payload)
      return if Nunes::Event.skip?(name)

      # Port the monotonic here to nunes as best we can so we have milli mono everywhere.
      duration = finish - start
      started_at = Nunes.now - duration
      finished_at = started_at + duration

      return unless (active_span = Nunes.tracer.active_span)

      parent_id = active_span.id
      trace_id = active_span.trace_id
      tags = Event.to_tags(name, payload)
      Nunes.manual_trace(name:, tags:, trace_id:, parent_id:, started_at:, finished_at:)
    end

    def tags_from_request(request)
      {
        verb: request.request_method,
        path: request.path,
        ip: request.ip,
        started_at: Time.now.to_i,
      }
    end

    def ignore?(request)
      Rails.application.config.nunes.ignored_requests.any? do |block|
        block.call(request)
      end
    end
  end
end
