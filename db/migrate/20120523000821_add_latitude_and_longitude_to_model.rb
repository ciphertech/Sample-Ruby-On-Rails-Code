class AddLatitudeAndLongitudeToModel < ActiveRecord::Migration
  def change
    add_column :restaurants, :latitude, :float
    add_column :restaurants, :longitude, :float
    add_column :vendors, :latitude, :float
    add_column :vendors, :longitude, :float
  end
end
