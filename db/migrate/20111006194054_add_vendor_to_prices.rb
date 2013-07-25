class AddVendorToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :vendor_id, :integer
  end
end
