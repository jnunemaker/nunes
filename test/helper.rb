ENV["RAILS_ENV"] = "test"

require "rails"
require "rails/test_help"

# require everything in the support directory
root = Pathname(__FILE__).dirname.join("..").expand_path
Dir[root.join("test/support/**/*.rb")].each { |f| require f }

class ActionController::TestCase
  include StatsdSocketTestHelpers
end

require "rails_app/config/environment"

require "railsd"
require "statsd"

Railsd::Subscribers::ActionController.subscribe(Statsd.new)
