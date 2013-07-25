class AddGlobalAndScopedDataToVendors < ActiveRecord::Migration
  def change
  	add_column :vendors, :globally_approved, :boolean, :null => false, :default => false
  	add_column :vendors, :restaurant_id, :integer
  	add_column :vendors, :created_by_id, :integer
  end
end
