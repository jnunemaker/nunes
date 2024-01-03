# frozen_string_literal: true

require 'erb'
require 'securerandom'
require_relative 'tracer'
require_relative 'middleware/presenters/request'

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
          @app.call(env).tap do |(status, headers, _body)|
            span.tag :status, status
            if (content_type = headers['content-type'] || headers['Content-Type'])
              span.tag :content_type, content_type
            end
          end
        end
      end
    end

    private

    def tags_from_request(request)
      {
        verb: request.request_method,
        path: request.path,
        ip: request.ip,
        id: request.env['HTTP_X_REQUEST_ID'] || SecureRandom.uuid,
        started_at: Time.now.to_i
      }
    end

    def ignore?(request)
      Rails.application.config.nunes.ignored_requests.any? do |block|
        block.call(request)
      end
    end
  end
end
