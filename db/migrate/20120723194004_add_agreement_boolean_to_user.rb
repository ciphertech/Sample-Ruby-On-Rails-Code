class AddAgreementBooleanToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :agreement, :boolean, :default => false
    User.reset_column_information
    User.update_all(:agreement => true)
  end

  def self.down
  	remove_column :users, :agreement
  end
end
