require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'json'
require 'logger'

module Khronos
  autoload :Config,     'khronos/config'
  autoload :Logger,     'khronos/logger'
  autoload :Scheduler,  'khronos/scheduler'

  autoload :Storage,    'khronos/storage'
  autoload :Server,     'khronos/server'
end

Khronos::Logger.setup!(Logger.new(STDOUT))
