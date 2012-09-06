module Khronos
  class Storage
    module Adapter
      module ActiveRecord

        class CreateScheduleLog < ::ActiveRecord::Migration
          def self.up
            create_table :schedule_logs do |t|
              t.integer  :schedule_id,   :null => false
              t.datetime :started_at,    :null => false
              t.datetime :finished_at,   :null => true
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
