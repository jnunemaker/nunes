# frozen_string_literal: true

require 'erb'
require 'securerandom'
require_relative 'tracer'

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
          result = @app.call(env)
          status, _headers, _body = result
          span.tag :status, status
          result
        end
      end
    end

    private

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
