class AddDeetsToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :url,    :string
    add_column :vendors, :phone, :string
    add_column :vendors, :fax,    :string
    add_column :vendors, :address,   :string
    add_column :vendors, :city,   :string
    add_column :vendors, :state,   :string
    add_column :vendors, :zip,   :string
    add_column :vendors, :email,   :string
    add_column :vendors, :logo,   :string
    add_column :vendors, :rating,   :float
  end
end
