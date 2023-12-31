# frozen_string_literal: true

require "helper"
require "nunes/adapters/moneta"
require "nunes/shared_adapter_tests"

class NunesAdaptersMonetaDefaultTest < Minitest::Test
  prepend Nunes::SharedAdapterTests

  def setup
    @adapter = Nunes::Adapters::Moneta.new
  end
end

class NunesAdaptersMonetaPstoreTest < Minitest::Test
  prepend Nunes::SharedAdapterTests

  def setup
    @pstore_file = Nunes.root.join("tmp").tap { |path| path.mkpath }.join("test.pstore")
    @adapter = Nunes::Adapters::Moneta.new(moneta: ::Moneta.new(:PStore, file: @pstore_file, threadsafe: true))
  end

  def teardown
    @pstore_file.unlink if @pstore_file.exist?
  end
end
