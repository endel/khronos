require 'json'

module Khronos
  class Storage
    module Adapter

      module ActiveRecord
        class Schedule < ::ActiveRecord::Base
          attr_accessible :context, :at, :recurrency, :task_url, :callbacks, :active
          has_many :logs, :class_name => ScheduleLog

          def callbacks=(options)
            write_attribute(:callbacks, options.to_json)
          end

          def callbacks
            JSON.parse(read_attribute(:callbacks) || '{}')
          end
        end
      end

    end
  end
end
