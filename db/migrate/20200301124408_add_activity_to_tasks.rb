class AddActivityToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :activity_at, :datetime
  end
end
