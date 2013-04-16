# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'railsd/version'

Gem::Specification.new do |spec|
  spec.name          = "railsd"
  spec.version       = Railsd::VERSION
  spec.authors       = ["John Nunemaker"]
  spec.email         = ["nunemaker@gmail.com"]
  spec.description   = %q{Automatic Rails instrumentation to Statsd.}
  spec.summary       = %q{Automatic Rails instrumentation to Statsd.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
