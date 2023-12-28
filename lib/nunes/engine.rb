module Nunes
  class Engine < Rails::Engine
    initializer "nunes.middleware" do |app|
      require "nunes/middleware"
      app.middleware.insert 0, Nunes::Middleware
    end
  end
end
