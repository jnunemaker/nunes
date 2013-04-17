require "railsd/adapter"

module Railsd
  module Adapters
    # Statsd is the assumed interface, so we don't need to override anything.
    class Statsd < ::Railsd::Adapter
    end
  end
end
