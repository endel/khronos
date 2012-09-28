require 'json'

module Khronos
  class Storage
    module Adapter

      module ActiveRecord
        class Schedule < ::ActiveRecord::Base
          attr_accessible :context, :at, :recurrency, :task_url, :callbacks, :active
          has_many :logs, :class_name => ScheduleLog

          class << self
            def fetch(time)
              self.find_by_sql([
                "UPDATE #{self.table_name} SET active = false WHERE at <= ? AND active = true RETURNING *", time
              ])
            end
          end

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
