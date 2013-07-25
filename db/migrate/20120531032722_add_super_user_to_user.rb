class AddSuperUserToUser < ActiveRecord::Migration
  def change
    add_column :users, :super_user, :integer, :default => 0
  end
end
