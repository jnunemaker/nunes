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
        request_id = env["HTTP_X_REQUEST_ID"] || SecureRandom.uuid
        tags = {
          type: "web",
          request_method: request.request_method,
          request_id: request_id,
          path: request.path,
          ip: request.ip,
          started_at: Time.now.utc,
        }
        Nunes.trace(request_id, tags: tags) { |span|
          @app.call(env).tap { |(status, headers, body)|
            span.tag :status, status
          }
        }
      end
    end

    private

    def ignore?(request)
      Rails.application.config.nunes.ignored_requests.any? { |block|
        block.call(request)
      }
    end
  end
end
