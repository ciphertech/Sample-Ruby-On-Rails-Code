class AddTypeToInventoryItems < ActiveRecord::Migration
  def change
  	add_column :inventory_items, :type, :string
  	add_column :inventories, :vendor_id, :integer
  end
end
