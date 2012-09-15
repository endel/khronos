module Khronos
  class Storage
    module Adapter

      module ActiveRecord
        class ScheduleLog < ::ActiveRecord::Base
          attr_accessible :schedule_id, :started_at, :status_code
          belongs_to :schedule
        end
      end

    end
  end
end
