# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zerial/version'

Gem::Specification.new do |spec|
  spec.name          = "zerial"
  spec.version       = Zerial::VERSION
  spec.authors       = ["Jell"]
  spec.email         = ["jean-louis@jawaninja.com"]
  spec.summary       = %q{Simple JSON serializer}
  spec.description   = %q{Simple JSON serializer/parser}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "money"
  spec.add_development_dependency "immutable_record"
end
