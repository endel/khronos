require 'khronos/storage/adapter/activerecord/migrations/schedule'
require 'khronos/storage/adapter/activerecord/migrations/schedule_log'

namespace :db do

  desc 'Create the database.'
  task :create do
    adapter = Khronos::Storage::Adapter.get(ENV['KHRONOS_STORAGE'])
    if adapter.name =~ /ActiveRecord/
      CreateSchedule.up
      CreateScheduleLog.up
    end
  end

  desc 'Destroy entire database.'
  task :drop do
    adapter = Khronos::Storage::Adapter.get(ENV['KHRONOS_STORAGE'])
    if adapter.name =~ /ActiveRecord/
      CreateSchedule.down
      CreateScheduleLog.down
    end
  end

end

