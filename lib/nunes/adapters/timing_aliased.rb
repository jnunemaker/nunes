require "nunes/adapter"

module Nunes
  module Adapters
    # Internal: Adapter that aliases timing to gauge. One of the supported
    # places to send instrumentation data is instrumentalapp.com. Their agent
    # uses gauge under the hood for timing information. This adapter is used to
    # adapter their gauge interface to the timing one used internally in the
    # gem. This should never need to be used directly by a user of the gem.
    class TimingAliased < ::Nunes::Adapter
      # Internal: Adapter timing to gauge.
      def timing(metric, duration)
        @client.gauge prepare(metric), duration
      end
    end
  end
end
