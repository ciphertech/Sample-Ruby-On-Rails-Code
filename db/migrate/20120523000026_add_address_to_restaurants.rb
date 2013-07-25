class AddAddressToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :url,    :string
    add_column :restaurants, :phone, :string
    add_column :restaurants, :fax,    :string
    add_column :restaurants, :address,   :string
    add_column :restaurants, :city,   :string
    add_column :restaurants, :state,   :string
    add_column :restaurants, :zip,   :string
    add_column :restaurants, :email,   :string
    add_column :restaurants, :logo,   :string
  end
end
