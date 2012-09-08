require 'uri'

module Khronos
  class Storage
    autoload :Adapter, 'khronos/storage/adapter'

    def initialize(uri=ENV['KHRONOS_STORAGE'])
      unless uri.nil?
        @adapter = Adapter.get(uri)

        self.migrate! if @adapter.name =~ /ActiveRecord/
        self.class.send(:include, @adapter)
      end
    end

    def logger=(logger)
      #
      # Change logger current adapter's logger
      #
      puts "WARNING: Storage#logger not implemented."
    end

    def truncate!
      Schedule.delete_all
      ScheduleLog.delete_all
    end

    protected

      def migrate!
        require 'khronos/storage/adapter/activerecord/migrations/schedule'
        require 'khronos/storage/adapter/activerecord/migrations/schedule_log'

        unless ActiveRecord::Base.connection.table_exists?(:schedules)
          Adapter::ActiveRecord::CreateSchedule.up
        else
          Logger.debug "Schedules table already exists."
        end

        unless ActiveRecord::Base.connection.table_exists?(:schedule_logs)
          Adapter::ActiveRecord::CreateScheduleLog.up
        else
          Logger.debug "ScheduleLog table already exists."
        end
      end

  end
end
