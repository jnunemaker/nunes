module Nunes
  module Plugins
    class ActiveRecord
      def self.install
        return if @installed

        ActiveSupport::Notifications.monotonic_subscribe('sql.active_record') do |_name, start, finish, event_id, payload|
          # Port the monotonic here to nunes as best we can so we have milli mono everywhere.
          duration = finish - start
          started_at = Nunes.now - duration
          finished_at = started_at + duration

          if (active_span = Nunes.tracer.active_span)
            parent_id = active_span.id
            trace_id = active_span.trace_id
            tags = {
              sql: payload[:sql],
              event_id:,
            }

            if (name = payload[:name])
              tags[:name] = name
            end

            if (statement_name = payload[:statement_name])
              tags[:statement_name] = statement_name
            end

            if (cached = payload[:cached])
              tags[:cached] = cached
            end

            span = Tracer::Span.new(name: 'sql.active_record', tags:, trace_id:, parent_id:, started_at:, finished_at:)
            Nunes.tracer.spans << span
          end
        end

        @installed = true
      end
    end
  end
end