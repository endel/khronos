require 'json'
require 'eventmachine'
require 'eventmachine/http-request'

module Khronos
  module Server

    class Runner < EM::Connection
      def post_init
        puts "-- someone connected to the server!"
      end

      def receive_data json
        schedule = JSON.parse(json)

        if (url = schedule['task_url'])
          http = EM::HttpRequest.new(url).get
          http.callback do
            puts "#{url}\n#{http.response_header.status} - #{http.response.length} bytes\n"
            puts http.response
          end

          http.errback do
            puts "#{url}\n" + http.error
          end
        end

        send_data ">>> you sent: #{schedule.inspect}"
        close_connection
      end

      def unbind
        puts "-- someone disconnected from the echo server!"
      end

    end

  end
end
