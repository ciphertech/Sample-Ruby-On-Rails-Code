class ChangeParToFloat < ActiveRecord::Migration
  def up
    change_column :inventory_items, :par, :float
  end

  def down
    change_column :inventory_items, :par, :integer
  end
end
