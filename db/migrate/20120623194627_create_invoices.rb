class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
    
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :vendor_id
      t.integer :invoice_format_id
      t.integer :status
      
      t.string :name  # constructed from vendor name...
      
      # will be for a scanned image of the invoice ?
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      
      t.string :invoice_number, :limit=>40  # how big should this be
      t.string :customer
      t.datetime :invoice_date
      t.string  :terms  # will hold whatever... can be a lot of shit? how big ?
      t.string :note  # any other not field needed
      t.text :data  # all other fields needed for this invoice, keyword value hash
      
      
      t.timestamps
    end
  end
end

