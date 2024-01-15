# frozen_string_literal: true

require_relative 'lib/nunes/version'
require_relative 'lib/nunes/metadata'

Gem::Specification.new do |spec|
  spec.name = 'nunes'
  spec.version = Nunes::VERSION
  spec.authors = ['John Nunemaker']
  spec.email = ['nunemaker@gmail.com']

  spec.summary = 'The friendly gem that instruments everything for you, like I would if I could.'
  spec.description = 'The friendly gem that instruments everything for you, like I would if I could.'
  spec.homepage = 'https://github.com/jnunemaker/nunes'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata = Nunes::METADATA

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'opentelemetry-instrumentation-mysql2'
  spec.add_dependency 'opentelemetry-instrumentation-net_http'
  spec.add_dependency 'opentelemetry-instrumentation-pg'
  spec.add_dependency 'opentelemetry-instrumentation-rack'
  spec.add_dependency 'opentelemetry-instrumentation-rails'
  spec.add_dependency 'opentelemetry-sdk'
  spec.add_dependency 'rails', '>= 7.0.0', '< 8.0.0'
end
