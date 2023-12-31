guard :minitest, all_on_start: false do
  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/helper\.rb$}) { 'test' }
  watch(%r{^app/models/.*$}) { 'test/nunes/adapters/active_record_test.rb' }
  watch(%r{^lib/nunes/shared_adapter_tests\.rb$}) {
    [
      "test/nunes/adapters/moneta_test.rb",
      "test/nunes/adapters/active_record_test.rb",
    ]
  }

end
