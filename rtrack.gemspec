# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtrack/version'

Gem::Specification.new do |spec|
  spec.name          = "rtrack"
  spec.version       = Rtrack::VERSION
  spec.authors       = ["marcwebbie"]
  spec.email         = ["marcwebbie@gmail.com"]
  spec.summary       = "RTrack is a object-oriented wrapper around ffmpeg to manipulate audiofiles easily from ruby code."
  spec.description   = "RTrack is a object-oriented wrapper around ffmpeg to manipulate audiofiles easily from ruby code."
  spec.homepage      = "http://github.com/marcwebbie/rtrack"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "wavefile", "~> 0.6.0"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
