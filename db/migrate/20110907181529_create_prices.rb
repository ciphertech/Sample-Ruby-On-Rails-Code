class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :product_id
      t.integer :unit_id
      t.integer :user_id

      t.timestamps
    end
  end
end
