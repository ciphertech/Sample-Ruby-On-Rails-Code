class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :unit_id
      t.integer :category_id

      t.timestamps
    end
  end
end
