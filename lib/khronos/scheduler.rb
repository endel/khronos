require 'socket'
require 'json'

module Khronos
  class Scheduler
    attr_reader :runner

    def initialize
      @runner = Config.instance.runner
    end

    def run(schedule)
      client = TCPSocket.new( @runner['host'], @runner['port'] )
      client.puts( schedule.to_json )

      while !(client.closed?) && (message = client.gets)
        puts message.inspect
        client.close
      end
    end

    def fetch(target_time=Time.now)
      Storage::Schedule.where(['at <= ?', target_time]).where(:active => true)
    end

  end
end

