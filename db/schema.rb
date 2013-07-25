# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130103224124) do

  create_table "_inventory_items_old_20120429", :force => true do |t|
    t.integer  "status"
    t.integer  "restaurant_id"
    t.integer  "product_location_id"
    t.integer  "product_id"
    t.float    "quantity"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_id"
    t.integer  "location_id"
    t.integer  "par"
    t.integer  "level"
    t.string   "name"
    t.decimal  "price",               :precision => 8, :scale => 2
    t.date     "price_date"
    t.decimal  "total_price",         :precision => 8, :scale => 2
    t.integer  "vender_id"
    t.integer  "category_id"
  end

  create_table "_inventory_items_old_20120429_1", :force => true do |t|
    t.integer  "status"
    t.integer  "restaurant_id"
    t.integer  "product_location_id"
    t.integer  "product_id"
    t.float    "quantity"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_id"
    t.integer  "location_id"
    t.integer  "par"
    t.integer  "level"
    t.text     "name"
    t.decimal  "price",               :precision => 8, :scale => 2
    t.date     "price_date"
    t.decimal  "total_price",         :precision => 8, :scale => 2
    t.integer  "vender_id"
    t.integer  "category_id"
  end

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "access",        :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usda"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "restaurant_id"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "rating",                         :default => 1
    t.string   "username"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "import_attachments", :force => true do |t|
    t.integer  "inventory_id"
    t.integer  "user_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.boolean  "processed",               :default => false, :null => false
    t.text     "processing_errors"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "inventories", :force => true do |t|
    t.integer  "status"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.date     "inventory_date"
    t.integer  "user_id"
    t.integer  "completed_by_id"
    t.datetime "archived_at"
    t.integer  "vendor_id"
  end

  create_table "inventory_items", :force => true do |t|
    t.integer  "status"
    t.integer  "restaurant_id"
    t.integer  "product_id"
    t.float    "quantity"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory_id"
    t.integer  "location_id"
    t.float    "par"
    t.string   "name"
    t.decimal  "price",                :precision => 8, :scale => 2
    t.date     "price_date"
    t.decimal  "total_price",          :precision => 8, :scale => 2
    t.integer  "vendor_id"
    t.integer  "category_id"
    t.integer  "rating"
    t.integer  "order"
    t.integer  "position"
    t.integer  "inventory_product_id"
    t.string   "type"
    t.datetime "archived_at"
    t.integer  "room_position"
    t.decimal  "last_price",           :precision => 8, :scale => 2
  end

  add_index "inventory_items", ["archived_at", "created_at"], :name => "index_inventory_items_on_archived_at_and_created_at"
  add_index "inventory_items", ["category_id"], :name => "index_inventory_items_on_category_id"
  add_index "inventory_items", ["name", "id", "restaurant_id"], :name => "index_inventory_items_on_name_and_id_and_restaurant_id"
  add_index "inventory_items", ["product_id", "vendor_id"], :name => "index_inventory_items_on_product_id_and_vendor_id"

  create_table "inventory_products", :force => true do |t|
    t.integer  "status"
    t.integer  "created_by_id"
    t.integer  "restaurant_id"
    t.string   "name"
    t.string   "source_type"
    t.string   "source_id"
    t.integer  "rating"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "invoices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "vendor_id"
    t.integer  "invoice_format_id"
    t.integer  "status"
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "invoice_number",     :limit => 40
    t.string   "customer"
    t.datetime "invoice_date"
    t.string   "terms"
    t.string   "note"
    t.text     "data"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.string   "message"
    t.string   "notification_type"
    t.integer  "triggered_by_id"
    t.integer  "user_id"
    t.string   "notifier_type"
    t.integer  "notifier_id"
    t.datetime "viewed_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "unit_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "products", ["ancestry"], :name => "index_products_on_ancestry"
  add_index "products", ["name", "id", "category_id"], :name => "index_products_on_name_and_id_and_category_id"
  add_index "products", ["name"], :name => "index_products_on_name"

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "phone"
    t.string   "fax"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "logo"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "gmaps"
    t.boolean  "globally_approved",  :default => false, :null => false
    t.string   "country",            :default => "USA", :null => false
  end

  add_index "restaurants", ["name", "id", "globally_approved"], :name => "index_restaurants_on_name_and_id_and_globally_approved"

  create_table "skus", :force => true do |t|
    t.string   "name"
    t.binary   "fips"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "skus", ["ancestry"], :name => "index_skus_on_ancestry"

  create_table "support_messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "super_user",                            :default => 0
    t.boolean  "get_email_notifications",               :default => true,  :null => false
    t.boolean  "agreement",                             :default => false
    t.string   "encrypted_password",                    :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "invitation_token",        :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "phone"
    t.string   "fax"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "logo"
    t.integer  "rating",             :default => 0,     :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "rating_count",       :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "gmaps"
    t.boolean  "globally_approved",  :default => false, :null => false
    t.integer  "restaurant_id"
    t.integer  "created_by_id"
    t.string   "type"
    t.string   "country",            :default => "USA", :null => false
  end

end
