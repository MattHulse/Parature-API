# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "parature/version"

Gem::Specification.new do |s|
  s.name        = "parature"
  s.version     = Parature::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Hulse"]
  s.email       = ["matt.hulse@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby gem for interacting with Parature API}
  s.description = %q{Ruby gem for interacting with Parature API}

  s.add_runtime_dependency 'httpclient', '2.2.1'
  s.add_runtime_dependency 'nokogiri'

  #s.rubyforge_project = "parature"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
