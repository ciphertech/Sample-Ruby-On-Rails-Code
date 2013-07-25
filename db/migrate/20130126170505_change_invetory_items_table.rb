class ChangeInvetoryItemsTable < ActiveRecord::Migration
  def up
  	change_column :inventory_items, :inventory_unit_qty, :float
  	change_column :inventory_items, :recipe_unit_qty, :float
  end

  def down
  end
end
