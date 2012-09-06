require 'observer'

module Khronos
  class Runner

    def update(time, command)
      puts "#{time.inspect} => #{command.inspect}"
    end

  end
end
