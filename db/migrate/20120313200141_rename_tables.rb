class RenameTables < ActiveRecord::Migration
  def up
    rename_table :inventoryitems, :inventory_items
    rename_table :productlocations, :product_locations
    
    rename_column :inventory_items, :productlocation_id, :product_location_id
  end

  def down
    rename_table :inventory_items, :inventoryitems
    rename_table :product_locations, :productlocations
  end
end
