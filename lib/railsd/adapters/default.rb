require "railsd/adapter"

module Railsd
  module Adapters
    # Internal: Default is the assumed interface, so we don't need to override
    # anything. This should never need to be used directly by a user of the gem.
    class Default < ::Railsd::Adapter
    end
  end
end
