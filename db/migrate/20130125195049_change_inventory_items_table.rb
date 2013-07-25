class ChangeInventoryItemsTable < ActiveRecord::Migration
   def self.up
    change_column :inventory_items, :inventory_unit_id,    :integer
    change_column :inventory_items, :inventory_unit_qty,   :float
    change_column :inventory_items, :inventory_unit_price, :float
    change_column :inventory_items, :recipe_unit_id,       :integer
    change_column :inventory_items, :recipe_unit_qty,      :float
    change_column :inventory_items, :recipe_unit_price,    :float
  end

  def self.down
  end
end
