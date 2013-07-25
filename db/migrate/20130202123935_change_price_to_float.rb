class ChangePriceToFloat < ActiveRecord::Migration
  def up
  	change_column :inventory_items, :price, :float
  end

  def down
  end
end
