class AddUserIdToProductlocation < ActiveRecord::Migration
  def self.up
    add_column :productlocations, :user_id, :integer
    
    Productlocation.find(:all).each do |pl|
      pl.user_id = pl.location.user_id
      pl.save
    end
  end
end
