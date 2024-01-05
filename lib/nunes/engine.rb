module Nunes
  class Engine < Rails::Engine
    isolate_namespace Nunes

    config.before_configuration do
      config.nunes = ActiveSupport::OrderedOptions.new.update(
        ignored_requests: [
          lambda { |request|
            %w[/nunes /mini-profiler-resources /vite-dev].any? do |path|
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

    initializer 'nunes.action_controller' do
      ActiveSupport.on_load(:action_controller) do
        require 'nunes/plugins/action_controller'
        Nunes::Plugins::ActionController.install
      end
    end

    initializer 'nunes.active_record' do
      ActiveSupport.on_load(:active_record) do
        require 'nunes/plugins/active_record'
        Nunes::Plugins::ActiveRecord.install
      end
    end
  end
end
