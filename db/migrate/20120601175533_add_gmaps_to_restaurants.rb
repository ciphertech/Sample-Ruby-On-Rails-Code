class AddGmapsToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :gmaps, :boolean
    add_column :vendors, :gmaps, :boolean
  end
end
