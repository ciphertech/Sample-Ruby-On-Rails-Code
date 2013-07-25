class CreateProductlocations < ActiveRecord::Migration
  def change
    create_table :productlocations do |t|
      t.integer :location_id
      t.integer :product_id

      t.timestamps
    end
  end
end
