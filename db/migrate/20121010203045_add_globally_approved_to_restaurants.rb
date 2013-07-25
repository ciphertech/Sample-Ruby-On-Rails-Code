class AddGloballyApprovedToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :globally_approved, :boolean, :null => false, :default => false
  end
end
