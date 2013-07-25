class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :name
      t.binary :fips

      t.timestamps
    end
  end
end
