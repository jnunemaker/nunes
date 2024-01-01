require_relative "base"

module Nunes
  class Middleware
    module Presenters
      class Request < Base
        def span
          __getobj__
        end

        def tags
          @tags ||= Hash[span.tags.map { |tag| [tag.key, tag.value] }]
        end

        def request_id
          tags[:id]
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

        def asset?
          css? || js? || image?
        end

        def css?
          path =~ /\.css\Z/i
        end

        def js?
          path =~ /\.js\Z/i
        end

        def image?
          path =~ /\.(png|jpg|jpeg|gif|bmp|tiff|ico)\Z/i
        end

        def status
          tags[:status]
        end

        def status_css_class
          case status[0]
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

        def started_at
          Time.at(tags[:started_at])
        end
      end
    end
  end
end
