class RenameUser < ActiveRecord::Migration
  def up
    rename_table :users, :restaurants
    rename_column :inventories, :user_id, :restaurant_id
    rename_column :inventory_items, :user_id, :restaurant_id
    rename_column :locations, :user_id, :restaurant_id
    rename_column :prices, :user_id, :restaurant_id
    rename_column :product_locations, :user_id, :restaurant_id
  end

  def down
    rename_table :restaurants, :users
    rename_column :inventories, :restaurant_id, :user_id
    rename_column :inventory_items, :restaurant_id, :user_id
    rename_column :locations, :restaurant_id, :user_id
    rename_column :prices, :restaurant_id, :user_id
    rename_column :product_locations, :restaurant_id, :user_id
  end
end
