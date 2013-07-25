class AddTypeToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :type, :string
  end
end
