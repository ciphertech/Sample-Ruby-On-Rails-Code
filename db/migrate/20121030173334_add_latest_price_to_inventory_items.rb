class AddLatestPriceToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :last_price, :decimal, :precision => 8, :scale => 2
  end
end
