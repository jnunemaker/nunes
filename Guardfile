guard :minitest, all_on_start: false do
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/helper\.rb$}) { 'test' }
  watch(%r{^app/models/.*$}) do
    [
      'test/nunes/adapters/active_record_test.rb',
      'test/integration/**/*.rb',
    ]
  end
  watch(%r{^app/controllers/(.*)\.rb$}) do |m|
    "test/integration/#{m[1].gsub(%r{nunes/}, '')}_test.rb"
  end
  watch(%r{lib/nunes/plugins/(action_controller|active_record)\.rb$}) do
    'test/integration/middleware_trace_test.rb'
  end
  watch(%r{^app/views/.*$}) { 'test/integration/controller_test.rb' }
  watch(%r{^lib/nunes/shared_adapter_tests\.rb$}) do
    Dir.glob('test/nunes/adapters/**/*.rb')
  end
end
