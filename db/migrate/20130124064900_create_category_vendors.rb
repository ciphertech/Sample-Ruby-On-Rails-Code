class CreateCategoryVendors < ActiveRecord::Migration
  def change
    create_table :category_vendors do |t|
      t.integer :vendor_id
      t.integer :category_id

      t.timestamps
    end
  end
end
