module Khronos
  class Storage
    module Adapter
      module ActiveRecord

        class CreateScheduleLog < ::ActiveRecord::Migration
          def self.up
            create_table :schedule_logs do |t|
              t.integer  :schedule_id,   :null => false
              t.datetime :started_at,    :null => false
              t.integer  :status_code,   :null => false
              t.string   :callbacks
            end
          end

          def self.down
            drop_table :schedule_logs
          end
        end

      end
    end
  end
end
