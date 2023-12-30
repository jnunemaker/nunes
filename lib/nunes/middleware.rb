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

    def render(view)
      contents = Nunes.root.join("lib", "nunes", "middleware", "views", "#{view}.erb").read
      body = ERB.new(contents).result(binding)
      [200, {'content-type' => 'text/html'}, [body]]
    end

    def call(env)
      request = Rack::Request.new(env)

      case request.path
      when %r{\A/nunes/requests/(?<request_id>.*)/?\Z}
        match = request.path_info.match(%r{\A/nunes/requests/(?<request_id>.*)/?\Z})
        request_id = match ? Rack::Utils.unescape(match[:request_id]) : nil

        span = Nunes.adapter.get(request_id)
        @request = Presenters::Request.new(span)

        render :request
      when %r{\A/nunes(/requests)?/?\Z}
        request_ids = Nunes.adapter.requests_index.first(30)
        @requests = Nunes.adapter.get_multi(request_ids).map { |_, span|
          Presenters::Request.new(span)
        }
        render :requests
      else
        # start tracing
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
  end
end
