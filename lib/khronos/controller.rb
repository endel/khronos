module Khronos
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
          @scheduler.run(schedule)
        end

        #
        # Sleep 'interval' seconds
        #
        sleep(Config.instance.interval)
      end
    end
  end
end
