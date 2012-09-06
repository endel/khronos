# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'khronos/version'

Gem::Specification.new do |s|
  s.name        = "khronos"
  s.version     = Khronos::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Endel Dreyer"]
  s.email       = ["endel@ocapi.com.br"]
  s.homepage    = "http://github.com/ocapi/khronos"

  s.summary     = "Ruby HTTP Job Scheduler Interface."
  s.description = "Ruby HTTP Job Scheduler Interface. An advanced Cron replacement for the cloud."
  s.licenses    = ['MIT']

  s.add_dependency "sinatra",       '~> 1.3.3'
  s.add_dependency 'mongoid',       '~> 3.0.5'
  s.add_dependency 'bson_ext',      '~> 1.6.4'
  s.add_dependency 'activerecord',  '~> 3.2.8'
  s.add_dependency 'json',          '~> 1.7.5'
  s.add_dependency 'activesupport', '~> 3.2.8'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
