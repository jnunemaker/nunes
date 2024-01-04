# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'minitest/autorun'

ENV['RAILS_ENV'] = 'test'
require_relative 'dummy/config/environment'
Rails.backtrace_cleaner.remove_silencers!

require 'nunes'

ActiveSupport::TestCase.setup do
  Nunes.reset
  Nunes::Span.delete_all
  Nunes::Tag.delete_all
end
