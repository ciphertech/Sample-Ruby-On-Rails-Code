class AddInventoryDateToInventories < ActiveRecord::Migration
  def change
     add_column :inventories, :inventory_date, :date
  end
end
