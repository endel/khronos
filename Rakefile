$: << 'lib'

require 'bundler/setup'

ENV['RACK_ENV'] = ENV['ENV'] || 'test'
require 'khronos'

def load_migrations!
  require 'khronos/storage/adapter/activerecord/migrations/schedule'
  require 'khronos/storage/adapter/activerecord/migrations/schedule_log'
end

namespace :db do

  desc 'Create the database.'
  task :create do
    adapter = Khronos::Storage::Adapter.get(ENV['KHRONOS_STORAGE'])
    if adapter.name =~ /ActiveRecord/
      load_migrations!
      CreateSchedule.up
      CreateScheduleLog.up
    end
  end

  desc 'Destroy entire database.'
  task :drop do
    adapter = Khronos::Storage::Adapter.get(ENV['KHRONOS_STORAGE'])
    if adapter.name =~ /ActiveRecord/
      load_migrations!
      CreateSchedule.down
      CreateScheduleLog.down
    end
  end

end

