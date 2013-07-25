class CreateSupportMessages < ActiveRecord::Migration
  def change
    create_table :support_messages do |t|
      t.string :name
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
