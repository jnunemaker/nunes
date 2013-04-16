module Railsd
  mattr_accessor :client
end

require "railsd/subscriber"
require "railsd/subscribers/action_controller"
