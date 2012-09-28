module Khronos
  module Server
    class Controller
      attr_reader :storage

      def initialize(runner=nil)
        @storage = Storage.new
        @runner = runner
      end

      def logger=(logger)
        puts "WARNING: Not implemented yet."
      end

      def check_schedule!
        puts "Checking... #{Time.now}"
        count = 0

        Storage::Schedule.fetch(Time.now).each do |schedule|
          @runner.enqueue(schedule)
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
