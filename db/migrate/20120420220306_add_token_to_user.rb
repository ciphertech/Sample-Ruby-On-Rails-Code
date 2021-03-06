class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    User.all.each do |user|
      user.generate_token
      user.save
    end
  end
end
