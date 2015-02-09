# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mr_hyde/version'

Gem::Specification.new do |spec|
  spec.name          = "mr_hyde"
  spec.version       = MrHyde::VERSION
  spec.authors       = ["Enrique Arias Cervero"]
  spec.email         = ["enrique.arias.cervero@gmail.com"]
  spec.summary       = %q{Mr. Hyde lets you generate and manage as many blogs as you want, something like Medium.}
  spec.description   = %q{Mr. Hyde lets you generate and manage as many blogs as you want, something like Medium.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.4.3"
  
  spec.add_runtime_dependency "jekyll", "~> 2.5.3"
end
