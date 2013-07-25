class AddInventoryIdToInvetoryitems < ActiveRecord::Migration
  def change
    add_column :inventoryitems, :inventory_id, :integer
  end
end
