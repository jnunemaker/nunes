module Railsd
  # Include and instrument. Simple class that makes it easy to instrument method
  # timing using ActiveSupport::Notifications.
  #
  # The event name is the name of the method being instrumented and the event
  # namespace is the name of the class the method is in.
  #
  # Examples
  #
  #   # To instrument an instance method, extend the module and instrument it.
  #   class User
  #     # Only need to do this once.
  #     extend Railsd::Instrumentable
  #
  #     def something
  #       # ...
  #     end
  #
  #     instrument_method_time :something
  #
  #     # you can customize the event and namespace by providing the name option
  #     instrument_method_time :something, {
  #       name: "something.else.User",
  #     }
  #
  #     # you can also add additional payload items
  #     instrument_method_time :something, {
  #       payload: {some: 'thing'},
  #     }
  #   end
  #
  #   # To instrument a class method, you need to extend the module on the
  #   # singleton class and use the same to call the method.
  #   class User
  #     # Only need to do this once.
  #     singleton_class.extend Railsd::Instrumentable
  #
  #     def self.something_class_level
  #       # ...
  #     end
  #
  #     singleton_class.instrument_method_time :someting_class_level
  #   end
  #
  module Instrumentable
    MethodTimeEventName = "instrument_method_time.railsd".freeze

    # Public: Instrument a method by name.
    #
    # method_name - The String or Symbol name of the method.
    # options_or_string - The Hash of options or the String metic name.
    #           :payload - Any items you would like to include with the
    #                      instrumentation payload.
    #           :name - The String name of the event and namespace.
    def instrument_method_time(method_name, options_or_string = nil)
      options = options_or_string || {}
      options = {name: options} if options.is_a?(String)

      action = :time
      payload = options.fetch(:payload) { {} }

      payload[:metric] = options.fetch(:name) {
        "#{self.name}/#{method_name}"
      }.to_s.underscore.gsub('/', '.')

      railsd_wrap_method(method_name, action) do |old_method_name, new_method_name|
        define_method(new_method_name) do |*args, &block|
          ActiveSupport::Notifications.instrument(MethodTimeEventName, payload) {
            result = send(old_method_name, *args, &block)

            payload[:arguments] = args
            payload[:result] = result

            result
          }
        end
      end
    end

    # So horrendously ugly...
    def railsd_wrap_method(method_name, action, &block)
      method_without_instrumentation = :"#{method_name}_without_#{action}"
      method_with_instrumentation = :"#{method_name}_with_#{action}"

      if method_defined?(method_without_instrumentation)
        raise ArgumentError, "already instrumented #{method_name} for #{self.name}"
      end

      if !method_defined?(method_name) && !private_method_defined?(method_name)
        raise ArgumentError, "could not find method #{method_name} for #{self.name}"
      end

      alias_method method_without_instrumentation, method_name
      yield method_without_instrumentation, method_with_instrumentation
      alias_method method_name, method_with_instrumentation
    end
  end
end
