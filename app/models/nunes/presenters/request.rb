# frozen_string_literal: true

require_relative "base"

module Nunes
  module Presenters
    class Request < Base
      def span
        __getobj__
      end

      def trace_started_at
        Time.at(tags[:started_at].to_i)
      end

      def ip
        tags[:ip]
      end

      def verb
        tags[:verb]
      end

      def path
        tags[:path]
      end

      def status
        tags[:status]
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
