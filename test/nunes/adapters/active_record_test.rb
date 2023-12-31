# frozen_string_literal: true

require "helper"
require "nunes/adapters/active_record"
require "nunes/shared_adapter_tests"

class NunesAdaptersActiveRecordTest < Nunes::Test
  prepend Nunes::SharedAdapterTests

  def setup
    Nunes::Span.delete_all
    Nunes::Tag.delete_all
    @adapter = Nunes::Adapters::ActiveRecord.new
  end
end
