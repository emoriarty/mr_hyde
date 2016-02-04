# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mr_hyde/version'

Gem::Specification.new do |spec|
  spec.name          = "mr_hyde"
  spec.version       = MrHyde::VERSION
  spec.authors       = ["Enrique Arias Cervero"]
  spec.email         = ["enrique.arias.cervero@gmail.com"]
  spec.summary       = %q{Mr. Hyde lets you generate and manage as many sites as you want.}
  spec.description   = %q{Mr. Hyde lets you generate and manage as many sites as you want, something similar like Medium. It's based on Jekyll.} 
  spec.homepage      = "https://github.com/emoriarty/mr_hyde"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.4", ">= 5.4.3"
  
  spec.add_runtime_dependency "jekyll", "~> 3.1", ">=3.1.1"
  spec.add_runtime_dependency "mercenary", "~> 0.3", ">=0.3.5"
end
