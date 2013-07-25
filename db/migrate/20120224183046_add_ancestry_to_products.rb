class AddAncestryToProducts < ActiveRecord::Migration
  def change
    add_column :products, :ancestry, :string
    add_index :products, :ancestry
  end
  
  def self.down
    remove_column :products, :ancestry
  end
end
