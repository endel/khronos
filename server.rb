$: << 'lib'
ENV['RACK_ENV'] = 'development'

require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'khronos'

#controller = Khronos::Controller.new
#controller.start!

case ARGV[0]
when 'runner'
  puts "Running: Runner."

  require 'khronos/server/runner'
  EventMachine.run {
    EventMachine.start_server Khronos::Config.instance.runner['host'], Khronos::Config.instance.runner['port'], Khronos::Server::Runner
  }

when 'scheduler'
  puts "Running: Scheduler."
  run Khronos::Server::Scheduler

when 'controller'
  controller = Khronos::Controller.new
  controller.start!

end
