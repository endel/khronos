
module Khronos
  class Storage
    module Adapter

      module ActiveRecord
        autoload :Schedule,     'khronos/storage/adapter/activerecord/schedule'
        autoload :ScheduleLog,  'khronos/storage/adapter/activerecord/schedule_log'

        def self.connect!(url)
          require 'active_record'

          ::ActiveRecord::Base.establish_connection(url)
          ::ActiveRecord::Base.include_root_in_json = false
          self
        end

        def self.included(base)
          self.migrate!
        end


        protected

        def self.migrate!
          require 'khronos/storage/adapter/activerecord/migrations/schedule'
          require 'khronos/storage/adapter/activerecord/migrations/schedule_log'

          unless ::ActiveRecord::Base.connection.table_exists?(:schedules)
            ActiveRecord::CreateSchedule.up
          else
            Logger.debug "Schedules table already exists."
          end

          unless ::ActiveRecord::Base.connection.table_exists?(:schedule_logs)
            ActiveRecord::CreateScheduleLog.up
          else
            Logger.debug "ScheduleLog table already exists."
          end
        end

      end

    end
  end
end


