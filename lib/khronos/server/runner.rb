require 'json'
require 'eventmachine'
require 'em-http'

module Khronos
  module Server

    class Runner < EventMachine::Connection
      def post_init
        puts "-- someone connected to the server!"
      end

      def receive_data json
        schedule = JSON.parse(json)
        send_data ">>> you sent: #{schedule.inspect}"

        # Close connection with client immediatelly
        close_connection

        if (url = schedule['task_url'])
          http = EventMachine::HttpRequest.new(url).get :redirects => 5
          http.callback do
            puts "#{url}\n#{http.response_header.status} - #{http.response.length} bytes\n"
            puts http.response
          end

          http.errback do
            puts "#{url}\n" + http.error
          end

          enqueue_recurrency!(schedule)
        end

      end

      def enqueue_recurrency!(schedule)
        url = "http://#{Config.instance.scheduler['host']}"
        url += ":#{Config.instance.scheduler['port']}" if Config.instance.scheduler['port']
        url += "/task?id=#{schedule['id']}"
        EventMachine::HttpRequest.new(url).patch :redirects => 2
      end

      def unbind
        puts "-- someone disconnected from the echo server!"
      end

    end

  end
end
