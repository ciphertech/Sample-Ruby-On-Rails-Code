class AddRoomSortToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :room_position, :integer
  end
end
