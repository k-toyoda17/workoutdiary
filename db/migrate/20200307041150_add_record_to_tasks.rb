class AddRecordToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :weight, :integer
    add_column :tasks, :lep, :integer
    add_column :tasks, :set, :integer
  end
end
