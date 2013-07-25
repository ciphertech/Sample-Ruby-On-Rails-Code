class AddArchivedAtToInventories < ActiveRecord::Migration
  def change
  	add_column :inventories, :archived_at, :datetime
  end
end
