module Khronos
  class Storage
    module Adapter

      module Mongoid
        class ScheduleLog
          include ::Mongoid::Document

          field :started_at,  :type => DateTime
          field :status_code, :type => Integer
          field :callbacks,   :type => String

          belongs_to :schedule
        end
      end

    end
  end
end
