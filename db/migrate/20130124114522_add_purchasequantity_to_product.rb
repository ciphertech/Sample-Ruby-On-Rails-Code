class AddPurchasequantityToProduct < ActiveRecord::Migration
  def self.up
    add_column    :products,    :unit_qty,             :float
  	remove_column :products,    :inventory_unit_price
  	remove_column :products,    :recipe_unit_price
    
  end

  def self.down
    remove_column :products,    :unit_qty
    
  	add_column :products,    :inventory_unit_price, :float
  	add_column :products,    :recipe_unit_price, :float
  end
end
