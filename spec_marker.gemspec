# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spec_marker/version'

Gem::Specification.new do |gem|
  gem.name          = "spec_marker"
  gem.version       = SpecMarker::VERSION
  gem.authors       = ["Shota Fukumori (sora_h)"]
  gem.email         = ["sorah@tubusu.net"]
  gem.description   = %q{Mark the timestamp of RSpec example starts/ends, and log other stuff for profiling}
  gem.summary       = %q{Mark the timestamp of RSpec example starts/ends, and log other stuff for profiling.}
  gem.homepage      = "https://github.com/sorah/spec_marker"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'rspec'
end
