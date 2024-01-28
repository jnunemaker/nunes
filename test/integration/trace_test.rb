# frozen_string_literal: true

require "helper"

module Nunes
  class TraceTest < ActionDispatch::IntegrationTest
    test "traces rails requests" do
      User.create(name: "Bob")
      get "/users"
      assert_response :success

      span = find_span("UsersController#index")
      assert_not_nil span

      assert_equal "UsersController#index", span.name
      assert_equal "www.example.com", span.property("http.host")
      assert_equal "GET", span.property("http.method")
      assert_equal "http", span.property("http.scheme")
      assert_equal "/users", span.property("http.target")
      assert_equal 200, span.property("http.status_code")
      assert_equal "UsersController", span.property("code.namespace")
      assert_equal "index", span.property("code.function")
    end

    test "traces active jobs" do
      perform_enqueued_jobs do
        get "/enqueue-job"
      end

      # at least one active job span
      active_job_spans = find_spans(/active_job/)
      assert_predicate active_job_spans, :present?

      # the job does a sql query
      sql_spans = find_spans(/sql/)
      assert_predicate sql_spans, :present?
    end

    test "traces rails requests with exception" do
      assert_raises RuntimeError do
        get "/boom"
      end

      span = find_span("KitchenSinkController#boom")
      assert_not_nil span

      assert_equal "KitchenSinkController#boom", span.name
      assert_equal "www.example.com", span.property("http.host")
      assert_equal "GET", span.property("http.method")
      assert_equal "http", span.property("http.scheme")
      assert_equal "/boom", span.property("http.target")
      assert_nil span.property("http.status_code")
      assert_equal "KitchenSinkController", span.property("code.namespace")
      assert_equal "boom", span.property("code.function")
      assert_not_nil event = span.events.first
      assert_equal "exception", event.name
      assert_equal "RuntimeError", event.property("exception.type")
      assert_equal "boom", event.property("exception.message")
      assert_not_nil event.property("exception.stacktrace")
      # assert_equal 2, span.status.code
    end

    test "traces rails active record sql" do
      get "/users"
      assert_response :success

      span = find_span("active_record sql")
      assert_not_nil span
      assert_equal 'SELECT "users".* FROM "users"', span.property("sql")
      assert_equal "User Load", span.property("name")
      assert_predicate span.property("binds"), :blank?
      assert_predicate span.property("type_casted_binds"), :blank?
      assert_not span.property("async")
    end

    private

    def find_span(...)
      find_spans(...).first
    end

    def find_spans(string_or_pattern)
      matcher = if string_or_pattern.is_a?(Regexp)
        ->(span) { span.name =~ string_or_pattern }
      else
        ->(span) { span.name == string_or_pattern }
      end

      Nunes::Span.all.select(&matcher)
    end
  end
end
