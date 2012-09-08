module Khronos
  class Storage
    module Adapter

      module Mongoid
        class Schedule
          include ::Mongoid::Document

          field :namespace,   :type => String
          field :context,     :type => String
          field :at,          :type => DateTime
          field :recurring,   :type => Integer
          field :active,      :type => Boolean

          has_many :logs, :class_name => ScheduleLog
        end
      end

    end
  end
end
