class AddNameToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :name, :string
  end
end
