# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fakturownia/version'

Gem::Specification.new do |spec|
  spec.name          = "fakturownia"
  spec.version       = Fakturownia::VERSION
  spec.authors       = ["Krzysztof Kempiński"]
  spec.email         = ["kkempin@gmail.com"]
  spec.description   = %q{This gem gives integration with polish on-line invoicing service: http://fakturownia.pl}
  spec.summary       = %q{Integration with fakturownia.pl}
  spec.homepage      = "https://github.com/kkempin/fakturownia"
  spec.license       = "MIT" 

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_rubygems_version = ">= 1.3.6"
  spec.add_dependency "rails", ">= 3.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
