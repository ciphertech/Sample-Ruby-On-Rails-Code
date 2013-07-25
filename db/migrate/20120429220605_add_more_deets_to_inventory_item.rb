class AddMoreDeetsToInventoryItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :price, :decimal, :precision => 8, :scale => 2
    add_column :inventory_items, :price_date, :date
    add_column :inventory_items, :total_price, :decimal, :precision => 8, :scale => 2
    add_column :inventory_items, :vendor_id, :integer
    add_column :inventory_items, :category_id, :integer
  end
end
