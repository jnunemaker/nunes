# frozen_string_literal: true

# https://guides.rubyonrails.org/active_support_instrumentation.html#active-record
module Nunes
  class Event # rubocop:disable Metrics/ClassLength
    def self.skip?(name)
      name.start_with?('!')
    end

    # Exception could be in any payload.
    # :exception	An array of two elements. Exception class name and the message
    # :exception_object	The exception object
    def self.to_tags(name, payload) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity,Metrics/AbcSize,Metrics/MethodLength
      tags = {}
      case name
      when 'send_file.action_controller'
        # :path	Complete path to the file
        %i[path].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'send_data.action_controller'
        # :status	HTTP response code
        # :location	URL to redirect to
        # :request	The ActionDispatch::Request object
        %i[status location].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'halted_callback.action_controller'
        # :filter	Filter that halted the action
        %i[filter].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'unpermitted_parameters.action_controller'
        # :keys	The unpermitted keys
        # :context	Hash with the following keys: :controller, :action, :params, :request
      when 'start_processing.action_controller'
        # :controller	The controller name
        # :action	The action
        # :params	Hash of request parameters without any filtered parameter
        # :headers	Request headers
        # :format	html/js/json/xml etc
        # :method	HTTP request verb
        # :path	Request path
        %i[controller action format path].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end

        if (value = payload[:method])
          tags[:verb] = value
        end
      when 'process_action.action_controller'
        # :controller	The controller name
        # :action	The action
        # :params	Hash of request parameters without any filtered parameter
        # :headers	Request headers
        # :format	html/js/json/xml etc
        # :method	HTTP request verb
        # :path	Request path
        # :request	The ActionDispatch::Request object
        # :response	The ActionDispatch::Response object
        # :status	HTTP status code
        # :view_runtime	Amount spent in view in ms
        # :db_runtime	Amount spent executing database queries in ms
        %i[controller action format path status view_runtime db_runtime].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end

        if (value = payload[:method])
          tags[:verb] = value
        end
      when 'write_fragment.action_controller'
        # :key	The complete key
        %i[key].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'read_fragment.action_controller'
        # :key	The complete key
        %i[key].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'expire_fragment.action_controller'
        # :key	The complete key
        %i[key].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'exist_fragment?.action_controller'
        # :key	The complete key
        %i[key].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'process_middleware.action_dispatch'
        # :middleware	Name of the middleware
        %i[middleware].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'redirect.action_dispatch'
        # :status	HTTP response code
        # :location	URL to redirect to
        # :request	The ActionDispatch::Request object
        %i[status location].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'request.action_dispatch'
        # :request	The ActionDispatch::Request object
      when 'render_template.action_view'
        # :identifier	Full path to template
        # :layout	Applicable layout
        # :locals	Local variables passed to template
        %i[identifier layout].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'render_partial.action_view'
        # :identifier	Full path to template
        # :locals	Local variables passed to template
        %i[identifier].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'render_collection.action_view'
        # :identifier	Full path to template
        # :count	Size of collection
        # :cache_hits	Number of partials fetched from cache
        %i[identifier count cache_hits].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'render_layout.action_view'
        # :identifier	Full path to template
        %i[identifier].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'sql.active_record'
        # :sql	SQL statement
        # :name	Name of the operation
        # :connection	Connection object
        # :binds	Bind parameters
        # :type_casted_binds	Typecasted bind parameters
        # :statement_name	SQL Statement name
        # :cached	true is added when cached queries used
        %i[sql name statement_name cached].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'strict_loading_violation.active_record'
        # :owner	Model with strict_loading enabled
        # :reflection	Reflection of the association that tried to load
      when 'instantiation.active_record'
        # :record_count	Number of records that instantiated
        # :class_name	Record's class
        %i[class_name record_count].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'deliver.action_mailer'
        # :mailer	Name of the mailer class
        # :message_id	ID of the message, generated by the Mail gem
        # :subject	Subject of the mail
        # :to	To address(es) of the mail
        # :from	From address of the mail
        # :bcc	BCC addresses of the mail
        # :cc	CC addresses of the mail
        # :date	Date of the mail
        # :mail	The encoded form of the mail
        # :perform_deliveries	Whether delivery of this message is performed or not
        %i[mailer message_id subject date perform_deliveries].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'process.action_mailer'
        # :mailer	Name of the mailer class
        # :action	The action
        # :args	The arguments
        %i[mailer action].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_read.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        # :hit	If this read is a hit
        # :super_operation	:fetch if a read is done with fetch
        %i[key store hit super_operation].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_read_multi.active_support'
        # :key	Keys used in the store
        # :store	Name of the store class
        # :hits	Keys of cache hits
        # :super_operation	:fetch_multi if a read is done with fetch_multi
        %i[key store hits super_operation].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_generate.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_fetch_hit.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_write.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_write_multi.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_increment.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        # :amount	Increment amount
        %i[key store amount].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_decrement.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        # :amount	Decrement amount
        %i[key store amount].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_delete.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_delete_multi.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_delete_matched.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_cleanup.active_support'
        # :store	Name of the store class
        # :size	Number of entries in the cache before cleanup
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_prune.active_support'
        # :store	Name of the store class
        # :key	Target size (in bytes) for the cache
        # :from	Size (in bytes) of the cache before prune
        %i[key store from].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'cache_exist?.active_support'
        # :key	Key used in the store
        # :store	Name of the store class
        %i[key store].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'message_serializer_fallback.active_support'
        # :serializer	Primary (intended) serializer
        # :fallback	Fallback (actual) serializer
        # :serialized	Serialized string
        # :deserialized	Deserialized value
      when 'enqueue_at.active_job'
        # :adapter	QueueAdapter object processing the job
        # :job	Job object
        %i[adapter].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'enqueue.active_job'
        # :adapter	QueueAdapter object processing the job
        # :job	Job object
        %i[adapter].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'enqueue_retry.active_job'
        # :adapter	QueueAdapter object processing the job
        # :job	Job object
        # :error	The error that caused the retry
        # :wait	The delay of the retry
        %i[adapter error wait].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'enqueue_all.active_job'
        # :adapter	QueueAdapter object processing the job
        # :jobs	An array of Job objects
        %i[adapter].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'perform_start.active_job'
        # :adapter	QueueAdapter object processing the job
        # :job	Job object
        %i[adapter].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'perform.active_job'
        # :adapter	QueueAdapter object processing the job
        # :job	Job object
        # :db_runtime	Amount spent executing database queries in ms
        %i[adapter db_runtime].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'retry_stopped.active_job'
        # :adapter	QueueAdapter object processing the job
        # :job	Job object
        # :error	The error that caused the retry
        %i[adapter error].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'discard.active_job'
        # :adapter	QueueAdapter object processing the job
        # :job	Job object
        # :error	The error that caused the discard
        %i[adapter error].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'perform_action.action_cable'
        # :channel_class	Name of the channel class
        # :action	The action
        # :data	A hash of data
        %i[channel_class action].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'transmit.action_cable'
        # :channel_class	Name of the channel class
        # :data	A hash of data
        # :via	Via
        %i[channel_class].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'transmit_subscription_confirmation.action_cable'
        # :channel_class	Name of the channel class
        %i[channel_class].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'transmit_subscription_rejection.action_cable'
        # :channel_class	Name of the channel class
        %i[channel_class].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'broadcast.action_cable'
        # :broadcasting	A named broadcasting
        # :message	A hash of message
        # :coder	The coder
      when 'preview.active_storage'
        # :key	Secure token
        %i[key].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'transform.active_storage'
      when 'analyze.active_storage'
        # :analyzer	Name of analyzer e.g., ffprobe
        %i[analyzer].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_upload.active_storage'
        # :key	Secure token
        # :service	Name of the service
        # :checksum	Checksum to ensure integrity
        %i[key service checksum].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_streaming_download.active_storage'
        # :key	Secure token
        # :service	Name of the service
        %i[key service].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_download_chunk.active_storage'
        # :key	Secure token
        # :service	Name of the service
        # :range	Byte range attempted to be read
        %i[key service].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_download.active_storage'
        # :key	Secure token
        # :service	Name of the service
      when 'service_delete.active_storage'
        # :key	Secure token
        # :service	Name of the service
        %i[key service].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_delete_prefixed.active_storage'
        # :key	Secure token
        # :service	Name of the service
        %i[key service].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_exist.active_storage'
        # :key	Secure token
        # :service	Name of the service
        # :exist	File or blob exists or not
        %i[key service exist].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_url.active_storage'
        # :key	Secure token
        # :service	Name of the service
        # :url	Generated URL
        %i[key service url].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'service_update_metadata.active_storage'
        # :key	Secure token
        # :service	Name of the service
        # :content_type	HTTP Content-Type field
        # :disposition	HTTP Content-Disposition field
        %i[key service content_type disposition].each do |key|
          if (value = payload[key])
            tags[key] = value
          end
        end
      when 'process.action_mailbox'
        # :mailbox	Instance of the Mailbox class inheriting from ActionMailbox::Base
        # :inbound_email	Hash with data about the inbound email being processed
      end

      tags
    end
  end
end
