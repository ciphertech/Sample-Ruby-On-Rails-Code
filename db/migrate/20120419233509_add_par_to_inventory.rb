class AddParToInventory < ActiveRecord::Migration
  def change
    add_column :inventory_items, :par, :integer
    add_column :inventory_items, :level, :integer
  end
end
