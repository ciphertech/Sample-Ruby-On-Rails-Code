class AddSortOrderToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :position, :integer
  end
end
