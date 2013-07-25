class AddPriceToPrices < ActiveRecord::Migration
  def change
    add_column :prices, :price, :decimal, :precision => 8, :scale => 2
    add_column :prices, :unit_price, :decimal, :precision => 8, :scale => 2
  end
end
