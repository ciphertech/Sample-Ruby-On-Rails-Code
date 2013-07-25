class AddColumnsToProducts < ActiveRecord::Migration
def self.up
    add_column :products,    :restaurant_id,        :integer
    add_column :products,    :inventory_unit_id,    :integer
    add_column :products,    :inventory_unit_qty,   :float
    add_column :products,    :inventory_unit_price, :float
    add_column :products,    :recipe_unit_id,       :integer
    add_column :products,    :recipe_unit_qty,      :float
    add_column :products,    :recipe_unit_price,    :float

    remove_column :products, :user_id
  end

  def self.down
    remove_column :products,    :restaurant_id        
    remove_column :products,    :inventory_unit_id    
    remove_column :products,    :inventory_unit_qty   
    remove_column :products,    :inventory_unit_price 
    remove_column :products,    :recipe_unit_id       
    remove_column :products,    :recipe_unit_qty   
    remove_column :products,    :recipe_unit_price    
    
    add_column    :products,    :user_id,            :integer
  end
end
