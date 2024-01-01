# frozen_string_literal: true

require "erb"
require "securerandom"
require_relative "tracer"
require_relative "middleware/presenters/request"

module Nunes
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if ignore?(request)
        @app.call(env)
      else
        Nunes.trace(:request, tags: tags_from_request(request)) { |span|
          @app.call(env).tap { |(status, headers, body)|
            span.tag :status, status
            if content_type = headers["content-type"] || headers["Content-Type"]
              span.tag :content_type, content_type
            end
          }
        }
      end
    end

    private

    def tags_from_request(request)
      {
        verb: request.request_method,
        path: request.path,
        ip: request.ip,
        id: request.env["HTTP_X_REQUEST_ID"] || SecureRandom.uuid,
        started_at: Time.now.utc,
      }
    end

    def ignore?(request)
      Rails.application.config.nunes.ignored_requests.any? { |block|
        block.call(request)
      }
    end
  end
end
