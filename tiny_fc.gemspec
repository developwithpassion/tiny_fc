# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib",__FILE__)
require "tiny_fc/version"

Gem::Specification.new do |s|
  s.name        = "tiny_fc"
  s.version     = TinyFC::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ["Develop With Passion®"]
  s.email       = ["open_source@developwithpassion.com"]
  s.homepage    = "http://www.developwithpassion.com"
  s.summary     = %q{Basic front controller lib}
  s.description = %q{Simple fc library}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency('rack', ">= 1.6.0")
  s.add_runtime_dependency('tilt', ">= 1.4.1")
  s.add_runtime_dependency('haml', ">= 4.0.6")
end
