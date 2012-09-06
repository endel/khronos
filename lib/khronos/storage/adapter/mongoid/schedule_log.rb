module Khronos
  class Storage
    module Adapter

      module Mongoid
        class ScheduleLog
          include ::Mongoid::Document

          field :started_at,  :type => DateTime
          field :finished_at, :type => DateTime

          belongs_to :schedule
        end
      end

    end
  end
end
