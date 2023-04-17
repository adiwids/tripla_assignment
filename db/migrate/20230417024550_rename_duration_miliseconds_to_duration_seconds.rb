class RenameDurationMilisecondsToDurationSeconds < ActiveRecord::Migration[7.0]
  def up
    rename_column :sleep_cycles, :duration_miliseconds, :duration_seconds
  end

  def down
    # don't rename to miliseconds on rollback
  end
end
