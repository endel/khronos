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
        @queue.push(schedule.to_json)
      end

      def process(json)
        schedule = JSON.parse(json)
        schedule_log = { :started_at => Time.now, :schedule_id => schedule['id'] }

        response = RestClient.get(schedule['task_url'])
        schedule_log[:status_code] = response.code

      rescue RestClient::Exception => e
        schedule_log[:status_code] = e.http_code

      ensure
        log_schedule!(schedule_log)
        calculate_recurrency!(schedule) if schedule['recurrency'].to_i > 0
      end

      def calculate_recurrency!(schedule)
        RestClient.put(scheduler_route('/task'), :id => schedule['id'], :patch => true)
      end

      def log_schedule!(schedule_log)
        puts "Log schedule! #{schedule_log.inspect}"
        RestClient.post( scheduler_route('/schedule/log'), schedule_log )
      end

      protected

        def scheduler_route(route)
          url = "http://#{Config.instance.scheduler['host']}"
          url += ":#{Config.instance.scheduler['port']}" if Config.instance.scheduler['port']
          url += route
        end

    end

  end
end

