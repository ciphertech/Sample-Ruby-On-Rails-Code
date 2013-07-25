class AddProductNameToPriceTest < ActiveRecord::Migration
  def change
    add_column :prices, :productname, :string
  end
end
