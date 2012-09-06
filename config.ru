$: << 'lib'
require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'khronos'

controller = Khronos::Controller.new
controller.start!

run Khronos::Server
