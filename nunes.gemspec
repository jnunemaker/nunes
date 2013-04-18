# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nunes/version'

Gem::Specification.new do |spec|
  spec.name          = "nunes"
  spec.version       = Nunes::VERSION
  spec.authors       = ["John Nunemaker"]
  spec.email         = ["nunemaker@gmail.com"]
  spec.description   = %q{The friendly gem that instruments everything for you, like I would if I could.}
  spec.summary       = %q{The friendly gem that instruments everything for you, like I would if I could.}
  spec.homepage      = "https://github.com/jnunemaker/nunes"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
end
