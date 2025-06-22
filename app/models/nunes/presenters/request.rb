# frozen_string_literal: true

require_relative "base"

module Nunes
  module Presenters
    class Request < Base
      def span
        __getobj__
      end

      def verb
        span.property("http.method")
      end

      def path
        span.property("http.target")
      end

      def status
        span.property("http.status_code")
      end

      def controller
        span.property("code.namespace")
      end

      def action
        span.property("code.function")
      end

      def status_css_class
        case status.to_s[0]
        when "1"
          "text-bg-primary"
        when "2"
          "text-bg-success"
        when "3"
          "text-bg-warning"
        when "4", "5"
          "text-bg-danger"
        else
          "text-bg-secondary"
        end
      end
    end
  end
end
