class AddInventoryProductToItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :inventory_product_id, :integer
  end
end
