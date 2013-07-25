class CreateInventoryitems < ActiveRecord::Migration
  def change
    create_table :inventoryitems do |t|
      t.integer :status
      t.integer :user_id
      t.integer :productlocation_id
      t.integer :product_id
      t.float :quantity
      t.integer :unit_id

      t.timestamps
    end
  end
end
