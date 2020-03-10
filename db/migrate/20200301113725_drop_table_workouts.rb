class DropTableWorkouts < ActiveRecord::Migration[5.2]
  def change
    drop_table :workouts
  end
end
