class CreateSleepCycles < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_cycles do |t|
      t.integer :user_id
      t.date :date
      t.datetime :set_wake_up_time
      t.datetime :actual_wake_up_time
      t.integer :duration_miliseconds
      t.integer :status, limit: 1, default: 0

      t.timestamps
    end

    add_index :sleep_cycles, :user_id
    add_index :sleep_cycles, :date
    add_index :sleep_cycles, :status
  end
end
