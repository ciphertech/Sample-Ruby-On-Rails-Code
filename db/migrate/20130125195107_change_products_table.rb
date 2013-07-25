class ChangeProductsTable < ActiveRecord::Migration
  def self.up
    change_column :products,    :restaurant_id,        :integer
    change_column :products,    :inventory_unit_id,    :integer
    change_column :products,    :inventory_unit_qty,   :float
    change_column :products,    :recipe_unit_id,       :integer
    change_column :products,    :recipe_unit_qty,      :float

    add_column :products,    :inventory_unit_price, :float
    add_column :products,    :recipe_unit_price,    :float
  end

  def self.down
  end
end
