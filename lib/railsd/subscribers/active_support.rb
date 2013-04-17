require "railsd/subscriber"

module Railsd
  module Subscribers
    class ActiveSupport < ::Railsd::Subscriber
      Pattern = /\.active_support\Z/

      def self.pattern
        Pattern
      end

      def cache_read(start, ending, transaction_id, payload)
        super_operation = payload[:super_operation]
        runtime = ((ending - start) * 1_000).round

        case super_operation
        when Symbol
          timing "active_support.cache_#{super_operation}", runtime
        else
          timing "active_support.cache_read", runtime
        end

        hit = payload[:hit]
        unless hit.nil?
          hit_type = hit ? :hit : :miss
          increment "active_support.cache_#{hit_type}"
        end
      end

      def cache_generate(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        timing "active_support.cache_generate", runtime
      end

      def cache_fetch_hit(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        timing "active_support.cache_fetch_hit", runtime
      end

      def cache_write(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        timing "active_support.cache_write", runtime
      end

      def cache_delete(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        timing "active_support.cache_delete", runtime
      end

      def cache_exist?(start, ending, transaction_id, payload)
        runtime = ((ending - start) * 1_000).round
        timing "active_support.cache_exist", runtime
      end
    end
  end
end
