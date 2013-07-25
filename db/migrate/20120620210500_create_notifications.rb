class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.string :notification_type
      t.integer :triggered_by_id
      t.integer :user_id
      t.string :notifier_type
      t.integer :notifier_id
      t.datetime :viewed_at

      t.timestamps
    end
  end
end
