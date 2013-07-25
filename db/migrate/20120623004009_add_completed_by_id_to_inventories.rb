class AddCompletedByIdToInventories < ActiveRecord::Migration
  def change
  	add_column :inventories, :completed_by_id, :integer
  end
end
