class AddCatnameToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :usda, :integer
  end
end
