class AddTokenAuthToUsers < ActiveRecord::Migration

  def self.up
    change_table(:users) do |t|
      t.string :authentication_token
    end

    add_index :users, :authentication_token, :unique => true

    User.reset_column_information

    User.find_each do |user|
      user.ensure_authentication_token!
    end
  end

  def self.down
    remove_column :users, :authentication_token
  end

end
