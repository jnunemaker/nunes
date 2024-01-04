module Nunes
  class Engine < Rails::Engine
    isolate_namespace Nunes

    config.before_configuration do
      config.nunes = ActiveSupport::OrderedOptions.new.update(
        ignored_requests: [
          ->(request) { request.path =~ %r{\A/nunes} },
          ->(request) { request.path =~ %r{\A/mini-profiler-resources} }
        ]
      )
    end

    initializer 'nunes.middleware' do |app|
      require 'nunes/middleware'
      app.middleware.insert 0, Nunes::Middleware
    end
  end
end
