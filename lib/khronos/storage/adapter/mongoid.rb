module Khronos
  class Storage
    module Adapter

      module Mongoid
        autoload :Schedule,     'khronos/storage/adapter/mongoid/schedule'
        autoload :ScheduleLog,  'khronos/storage/adapter/mongoid/schedule_log'

        def self.connect!(uri)
          require 'mongo'
          require 'mongoid'

          if File.exists?("config/mongoid.yml")
            ::Mongoid.load!("config/mongoid.yml")
          else
            ::Mongoid.configure do |config|
              config.connect_to uri[:host][1..-1]
            end
          end

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

