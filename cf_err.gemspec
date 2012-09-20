# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cf_err/version'

Gem::Specification.new do |gem|
  gem.name          = "cf_err"
  gem.version       = CfErr::VERSION
  gem.authors       = ["MillisamiSprout"]
  gem.email         = ["millisami@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'foreverb', '~> 0.3.0'
  gem.add_dependency 'nokogiri', '~> 1.5.5'
  gem.add_dependency 'sequel',   '~> 3.39'
  # gem.add_dependency 'curator',  '~> 0.8.1'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'turn'
  gem.add_development_dependency 'pagerduty'
  gem.add_development_dependency 'rr'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sqlite3'
end
