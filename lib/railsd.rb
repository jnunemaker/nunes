module Railsd
  mattr_accessor :client
end

require "railsd/instrumentable"
require "railsd/subscriber"
require "railsd/subscribers/action_controller"
require "railsd/subscribers/action_view"
require "railsd/subscribers/action_mailer"
require "railsd/subscribers/active_support"
require "railsd/subscribers/active_record"
require "railsd/subscribers/railsd"
