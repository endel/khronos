module Khronos
  module Server
    class Controller
      attr_reader :storage, :scheduler

      def initialize
        @storage = Storage.new
        @scheduler = Scheduler.new
      end

      def logger=(logger)
        puts "WARNING: Not implemented yet."
      end

      def start!
        loop do
          @scheduler.fetch(Time.now).each do |schedule|
            schedule.update_attributes(:status => false)
            schedule.save
            @scheduler.run(schedule)
          end

          #
          # Sleep 'interval' seconds
          #
          sleep(Config.instance.controller['interval'])
        end
      end
    end
  end
end
