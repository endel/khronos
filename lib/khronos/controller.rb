module Khronos
  class Controller
    attr_reader :scheduler, :runner, :interval

    def initialize
      @runner = Runner.new
      @scheduler = Scheduler.new
      @scheduler.add_observer(@runner)
    end

    def logger=(logger)
      puts "WARNING: Not implemented yet."
    end

    def start!
      loop do
        puts "Tick..."

        if rand(500) == 1
          puts "I'm so lucky!"
        end

        #
        # Sleep 'interval' seconds
        #
        sleep(Config.instance.interval)
      end
    end
  end
end
