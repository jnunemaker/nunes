# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"

ENV['RAILS_ENV'] = 'test'
require_relative "dummy/config/environment"
Rails.backtrace_cleaner.remove_silencers!

require "nunes"

class Nunes::Test < Minitest::Test
  def setup
    Nunes.reset
  end
end

class Nunes::IntegrationTest < ActionDispatch::IntegrationTest
  def setup
    Nunes.reset
  end
end
