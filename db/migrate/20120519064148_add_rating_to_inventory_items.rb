class AddRatingToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :rating, :integer
  end
end
