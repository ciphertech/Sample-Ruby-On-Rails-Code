class SetDefaultRatingForVendors < ActiveRecord::Migration
  def change
  	change_column :vendors, :rating, :integer, :null => false, :default => 0
  end
end
