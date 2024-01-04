# frozen_string_literal: true

require 'helper'
require 'nunes/middleware'
require 'rack'
require 'rack/test'

module Nunes
  class MiddlewareTest < ActiveSupport::TestCase
    include Rack::Test::Methods

    def app
      @app ||= Rack::Builder.new do
        use Middleware
        run lambda { |_env|
          body = Nunes.trace('render') { ['<html><body><h1>Hi</h1></body></html>'] }
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

      assert root = Nunes.adapter.all.first
      assert_equal 'request', root.name

      tags = Hash[root.tags.map { |tag| [tag.key, tag.value] }]

      assert_equal '/', tags[:path]
      assert_equal 200, tags[:status]
      assert_equal '127.0.0.1', tags[:ip]
      assert_equal '1234', tags[:id]
      assert_equal 'GET', tags[:verb]
      assert_equal 'text/html', tags[:content_type]
      refute_nil tags[:started_at]

      spans = Nunes.adapter.get(root.trace_id)
      assert_equal 2, spans.size
      assert_equal 'render', spans[1].name
    end
  end
end
