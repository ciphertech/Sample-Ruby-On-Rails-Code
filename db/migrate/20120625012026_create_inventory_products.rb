class CreateInventoryProducts < ActiveRecord::Migration
  def change
    create_table :inventory_products do |t|
      t.integer :status
  
      t.integer :created_by_id
      t.integer :restaurant_id
      
      t.string  :name
      
      t.string :source_type  # could be invoice_product
      t.string :source_id    # and this invoice_product_id
     
      t.integer :rating # doubt this will ever be used
      
      t.timestamps
    end
  end
end