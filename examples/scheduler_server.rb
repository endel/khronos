ENV['RACK_ENV'] = 'production'

require 'rubygems'
require 'khronos'

Khronos::Config.instance.load!('config/environment.yml', ENV['RACK_ENV'])
run Khronos::Server::Scheduler

