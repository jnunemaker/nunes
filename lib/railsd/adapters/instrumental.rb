require "railsd/adapter"

module Railsd
  module Adapters
    class Instrumental < ::Railsd::Adapter
      # Instrumental uses gauge for timing.
      def timing(metric, duration)
        @client.gauge metric, duration
      end
    end
  end
end
