class AddAncestryToSkus < ActiveRecord::Migration
  def change
    add_column :skus, :ancestry, :string
    add_index :skus, :ancestry
  end
end
