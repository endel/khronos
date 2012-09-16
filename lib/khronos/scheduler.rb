require 'socket'
require 'json'

module Khronos
  class Scheduler

    def self.run(schedule, runner=nil)
      schedule.update_attributes(:active => false)
      schedule.save
      runner.enqueue(schedule) if runner
    end

    def self.fetch(target_time=Time.now)
      Storage::Schedule.where(['at <= ?', target_time]).where(:active => true)
    end

  end
end

