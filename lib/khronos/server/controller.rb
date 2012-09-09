module Khronos
  module Server
    class Controller
      attr_reader :storage, :scheduler

      def initialize
        @storage = Storage.new
        @scheduler = Khronos::Scheduler.new
      end

      def logger=(logger)
        puts "WARNING: Not implemented yet."
      end

      def check_schedule!
        puts "Check... #{Time.now}"
        count = 0
        @scheduler.fetch(Time.now).each do |schedule|
          schedule.update_attributes(:status => false)
          schedule.save

          @scheduler.run(schedule)
          count += 1
        end
        puts "Tick. #{count} jobs to run."
      end

      def start!
        loop do
          check_schedule!

          #
          # Sleep 'interval' seconds
          #
          sleep(Config.instance.controller['interval'])
        end
      end
    end
  end
end
