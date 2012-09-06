module Khronos
  class Storage
    module Adapter
      module ActiveRecord

        class CreateSchedule < ::ActiveRecord::Migration
          def self.up
            create_table :schedules do |t|
              t.string    :namespace,   :limit => 100, :null => true
              t.string    :context,     :limit => 100, :null => false
              t.datetime  :at,                         :null => false
              t.string    :task_url,                   :null => false
              t.integer   :recurring,                  :null => false
            end
          end

          def self.down
            drop_table :schedules
          end
        end

      end
    end
  end
end
