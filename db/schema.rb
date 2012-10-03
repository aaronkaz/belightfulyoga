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

ActiveRecord::Schema.define(:version => 20121003013517) do

  create_table "admins", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "client_groups", :force => true do |t|
    t.string   "type"
    t.string   "code"
    t.string   "title"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "course_titles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "courses", :force => true do |t|
    t.integer  "client_group_id"
    t.integer  "course_title_id"
    t.boolean  "is_family",                                     :default => false
    t.date     "start_date"
    t.date     "end_date"
    t.date     "hide_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "day"
    t.text     "location"
    t.decimal  "price",           :precision => 8, :scale => 2
    t.text     "notes"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  add_index "courses", ["client_group_id"], :name => "index_courses_on_client_group_id"
  add_index "courses", ["course_title_id"], :name => "index_courses_on_course_title_id"

  create_table "page_part_placements", :force => true do |t|
    t.integer  "page_id"
    t.integer  "page_part_id"
    t.text     "text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "page_part_placements", ["page_id"], :name => "index_page_part_placements_on_page_id"
  add_index "page_part_placements", ["page_part_id"], :name => "index_page_part_placements_on_page_part_id"

  create_table "page_parts", :force => true do |t|
    t.string   "title"
    t.boolean  "wysiwyg",    :default => true
    t.boolean  "required",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.string   "link_title"
    t.string   "page_title"
    t.string   "permalink"
    t.boolean  "show_in_menu",        :default => true
    t.boolean  "skip_to_first_child", :default => false
    t.integer  "position"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "add_css"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.boolean  "google_analytics",    :default => true
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "client_group_id"
    t.boolean  "synced_to_mailchimp",    :default => false
    t.string   "first_name"
    t.string   "middle_initial"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "work_phone_ext"
    t.string   "cell_phone"
    t.string   "occupation"
    t.string   "emergency_contact"
    t.date     "birthdate"
    t.string   "guardian"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["client_group_id"], :name => "index_users_on_client_group_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
