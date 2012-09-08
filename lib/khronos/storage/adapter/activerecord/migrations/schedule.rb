module Khronos
  class Storage
    module Adapter
      module ActiveRecord

        class CreateSchedule < ::ActiveRecord::Migration
          def self.up
            create_table :schedules do |t|
              t.string    :context,    :null => false, :limit => 100
              t.datetime  :at,         :null => false
              t.string    :task_url,   :null => false
              t.integer   :recurrency, :null => false
              t.string    :callbacks,  :null => true,  :limit => 500
              t.boolean   :active,     :null => false, :default => true
            end

            add_index :schedules, :at
            add_index :schedules, :context
          end

          def self.down
            drop_table :schedules
          end
        end

      end
    end
  end
end
