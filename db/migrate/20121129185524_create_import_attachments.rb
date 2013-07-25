class CreateImportAttachments < ActiveRecord::Migration
  def change
    create_table :import_attachments do |t|
      t.integer   :inventory_id
      t.integer   :user_id
      t.string    :attachment_file_name
      t.string    :attachment_content_type
      t.integer   :attachment_file_size
      t.datetime  :attachment_updated_at
      t.boolean   :processed, :null => false, :default => false
      t.text      :processing_errors
      t.timestamps
    end
  end
end
