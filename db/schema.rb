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

ActiveRecord::Schema.define(:version => 20130903204642) do

  create_table "addresses", :force => true do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "admins", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
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
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "is_teacher",             :default => false
    t.string   "color"
    t.boolean  "admin",                  :default => false
    t.boolean  "show_on_web",            :default => false
    t.text     "bio"
    t.string   "photo"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "cart_promo_codes", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "promo_code_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "cart_promo_codes", ["cart_id", "promo_code_id"], :name => "index_cart_promo_codes_on_cart_id_and_promo_code_id"

  create_table "carts", :force => true do |t|
    t.string   "status"
    t.integer  "user_id"
    t.string   "postal_code"
    t.string   "selected_shipping_array"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.boolean  "shipping_confirm",        :default => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "session_id"
  end

  add_index "carts", ["billing_address_id"], :name => "index_carts_on_billing_address_id"
  add_index "carts", ["shipping_address_id"], :name => "index_carts_on_shipping_address_id"
  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

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
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "slug"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone"
    t.integer  "contact_person_id"
    t.text     "contact_notes"
  end

  add_index "client_groups", ["contact_person_id"], :name => "index_client_groups_on_contact_person_id"
  add_index "client_groups", ["slug"], :name => "index_client_groups_on_slug", :unique => true

  create_table "course_attendees", :force => true do |t|
    t.integer  "course_event_id"
    t.string   "attendable_type"
    t.integer  "attendable_id"
    t.boolean  "attended",                                      :default => false
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.boolean  "walk_in",                                       :default => false
    t.decimal  "paid",            :precision => 8, :scale => 2
    t.string   "payment_type"
  end

  add_index "course_attendees", ["attendable_type", "attendable_id"], :name => "index_course_attendees_on_attendable_type_and_attendable_id"
  add_index "course_attendees", ["course_event_id"], :name => "index_course_attendees_on_course_event_id"

  create_table "course_events", :force => true do |t|
    t.integer  "course_id"
    t.datetime "event_date"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "event_index"
    t.integer  "teacher_id"
    t.decimal  "teacher_pay_out", :precision => 8, :scale => 2
    t.datetime "paid"
  end

  add_index "course_events", ["course_id"], :name => "index_course_events_on_course_id"
  add_index "course_events", ["teacher_id"], :name => "index_course_events_on_teacher_id"

  create_table "course_registrations", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "registration_type"
    t.decimal  "paid",              :precision => 8, :scale => 2
  end

  add_index "course_registrations", ["cart_id"], :name => "index_course_registrations_on_cart_id"
  add_index "course_registrations", ["course_id"], :name => "index_course_registrations_on_course_id"
  add_index "course_registrations", ["user_id"], :name => "index_course_registrations_on_user_id"

  create_table "courses", :force => true do |t|
    t.integer  "client_group_id"
    t.boolean  "is_family",                                     :default => false
    t.date     "start_date"
    t.date     "end_date"
    t.date     "hide_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "day"
    t.text     "location"
    t.decimal  "price",           :precision => 8, :scale => 2, :default => 0.0
    t.text     "notes"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.text     "description"
    t.string   "image"
    t.string   "title"
    t.integer  "teacher_id"
    t.decimal  "paid_by_company", :precision => 8, :scale => 2, :default => 0.0
    t.integer  "length_minutes"
    t.decimal  "teacher_rate",    :precision => 8, :scale => 2
    t.integer  "old_id"
    t.boolean  "active",                                        :default => false
    t.string   "frequency"
    t.boolean  "reminder",                                      :default => false
  end

  add_index "courses", ["client_group_id"], :name => "index_courses_on_client_group_id"
  add_index "courses", ["teacher_id"], :name => "index_courses_on_teacher_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "image"
  end

  create_table "guests", :force => true do |t|
    t.integer  "waiver_id"
    t.string   "name"
    t.string   "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "guests", ["waiver_id"], :name => "index_guests_on_waiver_id"

  create_table "line_items", :force => true do |t|
    t.integer  "cart_id"
    t.string   "line_itemable_type"
    t.integer  "line_itemable_id"
    t.integer  "qty"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.decimal  "unit_price",         :precision => 8, :scale => 2
  end

  add_index "line_items", ["cart_id"], :name => "index_line_items_on_cart_id"
  add_index "line_items", ["line_itemable_type", "line_itemable_id"], :name => "index_line_items_on_line_itemable_type_and_line_itemable_id"

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
    t.string   "slug"
    t.string   "ancestry"
  end

  add_index "pages", ["ancestry"], :name => "index_pages_on_ancestry"
  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

  create_table "pay_outs", :force => true do |t|
    t.integer  "teacher_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "teacher_approved",                                 :default => false
    t.boolean  "admin_approved",                                   :default => false
    t.decimal  "calculated_pay_out", :precision => 8, :scale => 2
    t.decimal  "adjustments",        :precision => 8, :scale => 2
    t.decimal  "total_pay_out",      :precision => 8, :scale => 2
    t.datetime "paid_date"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
  end

  add_index "pay_outs", ["teacher_id"], :name => "index_pay_outs_on_teacher_id"

  create_table "promo_codes", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.date     "start_date"
    t.date     "expiration_date"
    t.string   "discount_type"
    t.decimal  "amount",             :precision => 6, :scale => 2
    t.integer  "must_have_qty"
    t.boolean  "unique",                                           :default => false
    t.string   "line_itemable_type"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month"
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "teachers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "color"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "client_group_id"
    t.boolean  "synced_to_mailchimp",                  :default => false
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
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["client_group_id"], :name => "index_users_on_client_group_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "waivers", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "middle_initial"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "work_phone_ext"
    t.string   "cell_phone"
    t.date     "birth_date"
    t.string   "email_address"
    t.string   "occupation"
    t.string   "emergency_contact"
    t.string   "referral"
    t.string   "signature"
    t.string   "guardian_of"
    t.string   "guardian_signature"
    t.string   "family_members"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "waivers", ["cart_id"], :name => "index_waivers_on_cart_id"
  add_index "waivers", ["user_id"], :name => "index_waivers_on_user_id"

end
