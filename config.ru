$: << 'lib'
require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'khronos'

#controller = Khronos::Controller.new
#controller.start!

run Khronos::Server::Scheduler

# Note that this will block current thread.
#EventMachine.run {
  #EventMachine.start_server "127.0.0.1", 8081, Khronos::Server::Runner
#}
