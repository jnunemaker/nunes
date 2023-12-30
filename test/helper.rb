# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "nunes"
require "minitest/autorun"

TMP_PATH = Nunes.root.join("..", "tmp").tap { |path| path.mkpath }
