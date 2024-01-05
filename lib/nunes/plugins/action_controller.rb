module Nunes
  module Plugins
    class ActionController
      def self.install
        return if @installed
        return unless defined?(::ActionController::Base)

        ::ActionController::Base.around_action(&method(:around_action))

        @installed = true
      end

      def self.around_action(controller, block)
        ignored = Rails.application.config.nunes.ignored_requests.any? do |proc|
          proc.call(controller.request)
        end

        if ignored
          block.call
        else
          tags = {
            controller: controller.class.name,
            action: controller.action_name,
            format: controller.request.format.ref,
            verb: controller.request.request_method,
            path: controller.request.filtered_path,
          }

          # TODO: Add storage for these...
          # request: controller.request,
          # params: controller.request.filtered_parameters,
          # headers: controller.request.headers,

          Nunes.trace('process_action.action_controller', tags:) { block.call }
        end
      end
    end
  end
end
