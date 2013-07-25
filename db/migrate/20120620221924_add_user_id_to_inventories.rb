class AddUserIdToInventories < ActiveRecord::Migration
  def change
  	add_column :inventories, :user_id, :integer
  	add_column :users, :get_email_notifications, :boolean, null: false, default: true
  end
end
