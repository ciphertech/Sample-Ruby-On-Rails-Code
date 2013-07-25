class AddLocationIdToInventoryItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :location_id, :integer

  end
end
