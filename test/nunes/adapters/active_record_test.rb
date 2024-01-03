# frozen_string_literal: true

require 'helper'
require 'nunes/adapters/active_record'
require 'nunes/shared_adapter_tests'

module Nunes
  module Adapters
    class ActiveRecordTest < Nunes::Test
      prepend Nunes::SharedAdapterTests

      def setup
        Span.delete_all
        Tag.delete_all
        @adapter = ActiveRecord.new
      end
    end
  end
end
