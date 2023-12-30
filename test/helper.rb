# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"


ENV['RAILS_ENV'] = 'test'
require_relative "dummy/config/environment"

require "nunes"
TMP_PATH = Nunes.root.join("..", "tmp").tap { |path| path.mkpath }
