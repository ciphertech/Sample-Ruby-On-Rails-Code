class ReOrderExistingInventoryItems < ActiveRecord::Migration
  def up

    Restaurant.all.each do |restaurant|
      restaurant.inventories.each do |inventory|
        inventory_items = InventoryItem.unscoped.where(:inventory_id => inventory.id).order('inventory_items.created_at ASC').group_by(&:location_id).each do |location_id, items|
          items.each_with_index do |item, i|
            item.room_position = i + 1
            item.save
          end
        end
      end
    end

  end

  def down
  end
end
