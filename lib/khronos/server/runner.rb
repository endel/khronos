require 'rest-client'
require 'json'
require 'girl_friday'

module Khronos
  module Server

    class Runner < GirlFriday::WorkQueue
      attr_reader :queue

      def initialize(*args)
        @queue = self
        super(*args) do |schedule|
          self.process(schedule)
        end
      end

      def enqueue(schedule)
        puts "Khronos::Server::Runner#enqueue => #{schedule.inspect}"
        @queue.push(schedule.to_json)
      end

      def process(json)
        schedule = JSON.parse(json)
        puts "Khronos::Server::Runner#process => #{schedule.inspect}"

        if (url = schedule['task_url'])
          begin
            response = RestClient.get(url)
            puts "Callback: success. response length: #{response.length.inspect}"
          rescue Exception => e
            puts "Callback: error. (#{e.inspect})"
          end
          calculate_recurrency!(schedule)
        end
      end

      def calculate_recurrency!(schedule)
        url = "http://#{Config.instance.scheduler['host']}"
        url += ":#{Config.instance.scheduler['port']}" if Config.instance.scheduler['port']
        url += "/task"
        RestClient.patch(url, :id => schedule['id'])
      end

    end

  end
end

