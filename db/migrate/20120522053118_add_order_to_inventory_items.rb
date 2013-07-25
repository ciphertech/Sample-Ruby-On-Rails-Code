class AddOrderToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :order, :integer
    remove_column :inventory_items, :level
  end
end
