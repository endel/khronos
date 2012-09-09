require 'active_record'

module Khronos
  class Storage
    module Adapter

      module ActiveRecord
        autoload :Schedule,     'khronos/storage/adapter/activerecord/schedule'
        autoload :ScheduleLog,  'khronos/storage/adapter/activerecord/schedule_log'

        def self.connect!(url)
          puts "Connect! => #{url.inspect}"
          if File.exists?("config/database.yml")
            ::ActiveRecord::Base.establish_connection(YAML.load_file("config/database.yml")[ENV['RACK_ENV']])
          else
            ::ActiveRecord::Base.establish_connection(url)
          end

          #
          # ::ActiveRecord::Base.logger = ::Logger.new(STDOUT)
          #
          self
        end

        def self.included(base)
          #puts "included in #{base}"
        end

        def self.extended(base)
          #puts "extended in #{base.inspect}"
        end

      end

    end
  end
end


