class RemoveBogusInvItems < ActiveRecord::Migration
  def up
    @i = InventoryItem.find(:all)
    @i.each do |i|
      puts i.inventory.id rescue
        i.destroy 
    end
    
    @i = InventoryItem.find(:all)
    @i.each do |i|
      puts "current:"+i.restaurant_id.to_s()
      puts "real:"+i.inventory.restaurant_id.to_s()
      i.restaurant_id = i.inventory.restaurant_id
      i.save
    end
    
  end

  def down
  end
end
