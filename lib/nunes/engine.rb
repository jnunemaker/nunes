module Nunes
  class Engine < Rails::Engine
    isolate_namespace Nunes

    config.before_configuration do
      config.nunes = ActiveSupport::OrderedOptions.new.update(
        ignored_requests: [
          lambda { |request|
            %w[
              /nunes
              /mini-profiler-resources
              /vite-dev
              /site.webmanifest
              /favicon-16x16.png
              /favicon-32x32.png
              /ahoy/events
            ].any? do |path|
              request.path.start_with?(path)
            end
          },
        ]
      )
    end

    initializer 'nunes.middleware' do |app|
      require 'nunes/middleware'
      app.middleware.insert 0, Nunes::Middleware
    end
  end
end
