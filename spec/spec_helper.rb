# encoding: utf-8
$: << File.expand_path('lib')

ENV['RACK_ENV'] = 'test'

#
# Code coverage
#
require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'active_support/all'
require 'rack/test'
require 'delorean'
require 'webmock/rspec'

require 'rspec'
require 'khronos'
require 'fileutils'

FileUtils.mkdir_p('spec/tmp')
Khronos::Config.instance.load!('config/environment.yml', ENV['RACK_ENV'])

require 'factory_girl'
def load_factory_girl!
  require File.expand_path('spec/support/factories')
end

# Support mocks
require File.expand_path('spec/support/mocks')

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :rspec
end

Dir['spec/tmp/**'].each {|f| File.unlink(f) }
