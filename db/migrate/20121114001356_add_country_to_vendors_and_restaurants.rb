class AddCountryToVendorsAndRestaurants < ActiveRecord::Migration
  def change
    add_column :vendors, :country, :string, :null => false, :default => "USA"
    add_column :restaurants, :country, :string, :null => false, :default => "USA"
  end
end
