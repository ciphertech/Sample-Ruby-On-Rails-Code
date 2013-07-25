class AddArchivedAtToInventoryItems < ActiveRecord::Migration
  def change
  	add_column :inventory_items, :archived_at, :datetime
  end
end
