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
require 'rspec'

require 'khronos'
