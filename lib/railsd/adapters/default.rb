require "railsd/adapter"

module Railsd
  module Adapters
    # Default is the assumed interface, so we don't need to override anything.
    class Default < ::Railsd::Adapter
    end
  end
end
