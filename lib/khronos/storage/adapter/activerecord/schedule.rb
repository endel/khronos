module Khronos
  class Storage
    module Adapter

      module ActiveRecord
        class Schedule < ::ActiveRecord::Base
          attr_accessible :context, :at, :recurring, :task_url, :active
          has_many :logs, :class_name => ScheduleLog
        end
      end

    end
  end
end
