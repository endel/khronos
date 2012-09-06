module Khronos
  class Storage
    module Adapter

      module ActiveRecord
        class Schedule < ::ActiveRecord::Base
          attr_accessible :namespace, :context, :at, :recurring, :task_url
          has_many :logs, :class_name => ScheduleLog
        end
      end

    end
  end
end
