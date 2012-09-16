ENV['RACK_ENV'] = 'production'

require 'rubygems'
require 'khronos'
require 'khronos/version'

require 'girl_friday'
require 'redis'
require 'connection_pool'

ENV['REDISTOGO_URL'] ||= "redis://127.0.0.1:6379/0"

$redis = ConnectionPool::Wrapper.new(:size => 2, :timeout => 3) { Redis.connect(:url => ENV["REDISTOGO_URL"]) }
runner = Khronos::Server::Runner.new(:runner, :store => GirlFriday::Store::Redis, :store_config => { :pool => $redis })

Khronos::Config.instance.load!('config/environment.yml', ENV['RACK_ENV'])
Khronos::Server::Controller.new(runner).start!
