require 'socket'
require 'json'

module Khronos
  class Scheduler
    module Methods
      def run(schedule)
        client = TCPSocket.new( Config.instance.runner['host'], Config.instance.runner['port'] )
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

    include Methods
    extend Methods
  end
end

