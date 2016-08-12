ENV["RAILS_ENV"] = "test"

require "rails"
require "rails/test_help"
require "action_mailer"

# require everything in the support directory
root = Pathname(__FILE__).dirname.join("..").expand_path
Dir[root.join("test/support/**/*.rb")].each { |f| require f }

puts "Running tests against rails version #{Rails.version}"

class ActionController::TestCase
  include AdapterTestHelpers
end

class ActionMailer::TestCase
  include AdapterTestHelpers
end

class ActiveSupport::TestCase
  include AdapterTestHelpers
end

rails_version = ENV["RAILS_VERSION"] || "4.2.5"

require "rails_app_#{rails_version}/config/environment"

require "nunes"
