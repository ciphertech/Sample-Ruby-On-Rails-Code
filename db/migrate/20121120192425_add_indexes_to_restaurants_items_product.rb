class AddIndexesToRestaurantsItemsProduct < ActiveRecord::Migration
  def change
    add_index :restaurants, [:name, :id, :globally_approved]
    add_index :inventory_items, [:name, :id, :restaurant_id]
    add_index :inventory_items, [:product_id, :vendor_id] 
    add_index :inventory_items, [:category_id]
    add_index :inventory_items, [:archived_at, :created_at]
    add_index :products, [:name, :id, :category_id]
  end
end
