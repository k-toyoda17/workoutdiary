class ChangeWeightToTasks < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :weight, :float
  end
end
