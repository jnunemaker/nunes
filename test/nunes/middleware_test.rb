# frozen_string_literal: true

require "test_helper"
require "nunes/middleware"
require "rack"
require "rack/test"

class NunesMiddlewareTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    Nunes.reset
  end

  def app
    @app ||= Rack::Builder.new do
      use Nunes::Middleware
      run lambda { |env|
        body = Nunes.span("render") { ['<html><body><h1>Hi</h1></body></html>'] }
        [200, { 'content-type' => 'text/html' }, body]
      }
    end.to_app
  end

  def test_it
    env = Rack::MockRequest.env_for('/', 'HTTP_X_REQUEST_ID' => '1234')
    get '/', {}, env

    assert root = Nunes.adapter.get("1234")
    assert_equal "1234", root.name

    tags = Hash[root.tags.map { |tag| [tag.key, tag.value] }]

    assert_equal "/", tags[:path]
    assert_equal "200", tags[:status]
    assert_equal "127.0.0.1", tags[:ip]
    assert_equal "1234", tags[:request_id]
    assert_equal "GET", tags[:request_method]

    assert_equal 1, root.spans.size
    assert_equal "render", root.spans[0].name
  end
end
