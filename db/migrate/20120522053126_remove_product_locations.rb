class RemoveProductLocations < ActiveRecord::Migration
  def change
    remove_column :inventory_items, :product_location_id
    drop_table :product_locations
  end
end
