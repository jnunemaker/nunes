guard :minitest, all_on_start: false do
  watch(/.*\.rb/) { "test" }
  # integration_tests = Dir.glob('test/integration/**/*_test.rb')
  # watch(%r{^test/(.*)/?(.*)_test\.rb$})
  # watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}#{m[2]}_test.rb" }

  # watch(%r{^test/helper\.rb$}) { 'test' }

  # watch(%r{^app/controllers/(.*)\.rb$}) do |m|
  #   "test/integration/#{m[1].gsub(%r{nunes/}, '')}_test.rb"
  # end

  # watch(%r{^lib/nunes/engine\.rb$}) { integration_tests }
  # watch(%r{^app/models/.*$}) { integration_tests }
  # watch(%r{^app/views/.*$}) { integration_tests }
end
