# -*- encoding: utf-8 -*-
require File.expand_path('../lib/at-random/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Steve Dee"]
  gem.email         = ["steve@smartercode.net"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{Do things at random times}
  gem.homepage      = "https://github.com/mrdomino/at-random"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "at-random"
  gem.require_paths = ["lib"]
  gem.version       = AtRandom::VERSION

  gem.add_development_dependency 'rspec', ['>= 2']
  gem.add_development_dependency 'mocha'
end
