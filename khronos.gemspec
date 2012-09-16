# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'khronos/version'

Gem::Specification.new do |s|
  s.name        = "khronos"
  s.version     = Khronos::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Endel Dreyer"]
  s.email       = ["endel.dreyer@gmail.com"]
  s.homepage    = "http://github.com/endel/khronos"

  s.summary     = "Simple HTTP-based Job scheduling for the cloud."
  s.description = "Simple HTTP-based Job scheduling for the cloud."
  s.licenses    = ['MIT']

  s.add_dependency "sinatra",         "~> 1.3.3"
  s.add_dependency "activerecord",    "~> 3.2.8"
  s.add_dependency "json",            "~> 1.7.5"
  s.add_dependency "rest-client",     "~> 1.6.7"
  s.add_dependency "girl_friday",     "~> 0.10.0"

  s.add_development_dependency "mongoid",         "~> 3.0.5"
  s.add_development_dependency "bson_ext",        "~> 1.6.4"
  s.add_development_dependency "activesupport",   "~> 3.2.8"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
