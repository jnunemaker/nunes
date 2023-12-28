# frozen_string_literal: true

require "securerandom"
require_relative "tracer"

module Nunes
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      request_id = env["HTTP_X_REQUEST_ID"] || SecureRandom.uuid
      tags = {
        request_method: request.request_method,
        request_id: request_id,
        path: request.path,
        ip: request.ip,
      }
      Nunes.trace(request_id, tags: tags) { |span|
        @app.call(env).tap { |(status, headers, body)|
          span.tag :status, status
        }
      }
    end
  end
end
