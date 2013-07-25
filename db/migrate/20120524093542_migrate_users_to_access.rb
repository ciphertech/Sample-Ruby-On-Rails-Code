class MigrateUsersToAccess < ActiveRecord::Migration
  def up
    users = User.find(:all)
    Restaurant.find(:all).each do |r|
      users.each do |u|
        a = Account.new
        a.user = u
        a.restaurant = r
        if (u.id == 2)
          a.access = 1
        end
        a.save
      end
    end
  end

  def down
  end
end
