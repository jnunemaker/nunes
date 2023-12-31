# frozen_string_literal: true

require "helper"
require "nunes/middleware"
require "rack"
require "rack/test"

module Nunes
  class MiddlewareTest < Nunes::Test
    include Rack::Test::Methods

    def setup
      Nunes.reset
    end

    def app
      @app ||= Rack::Builder.new do
        use Middleware
        run lambda { |env|
          body = Nunes.span("render") { ['<html><body><h1>Hi</h1></body></html>'] }
          [200, { 'content-type' => 'text/html' }, body]
        }
      end.to_app
    end

    def test_tracing
      Nunes.configure do |config|
        config.adapter { Adapters::Memory.new }
      end
      env = Rack::MockRequest.env_for('/', 'HTTP_X_REQUEST_ID' => '1234')
      get '/', {}, env

      assert root = Nunes.adapter.get("1234")
      assert_equal "request", root.name

      tags = Hash[root.tags.map { |tag| [tag.key, tag.value] }]

      assert_equal "/", tags[:path]
      assert_equal "200", tags[:status]
      assert_equal "127.0.0.1", tags[:ip]
      assert_equal "1234", tags[:id]
      assert_equal "GET", tags[:verb]

      assert_equal 1, root.spans.size
      assert_equal "render", root.spans[0].name
    end
  end
end
