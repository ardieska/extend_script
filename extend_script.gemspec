# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'extend_script/version'

Gem::Specification.new do |spec|
  spec.name          = "extend_script"
  spec.version       = ExtendScript::VERSION
  spec.authors       = ["milligramme"]
  spec.email         = ["milligramme.cc@gmail.com"]

  spec.summary       = %q{adobe jsx utility.}
  spec.homepage      = "https://github.com/milligramme/extend_script"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_runtime_dependency "thor", "~> 0.19"
end
