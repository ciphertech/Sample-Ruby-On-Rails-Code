class AddUnitColumnsToInventryItems < ActiveRecord::Migration
  def self.up
    add_column :inventory_items, :inventory_unit_id,    :integer
    add_column :inventory_items, :inventory_unit_qty,   :float
    add_column :inventory_items, :inventory_unit_price, :float
    add_column :inventory_items, :recipe_unit_id,       :integer
    add_column :inventory_items, :recipe_unit_qty,      :float
    add_column :inventory_items, :recipe_unit_price,    :float
  end

  def self.down
    remove_column :inventory_items, :inventory_unit_id
    remove_column :inventory_items, :inventory_unit_qty
    remove_column :inventory_items, :inventory_unit_price
    remove_column :inventory_items, :recipe_unit_id
    remove_column :inventory_items, :recipe_unit_qty
    remove_column :inventory_items, :recipe_unit_price
  end
end
