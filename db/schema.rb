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

ActiveRecord::Schema.define(:version => 20101225025630) do

  create_table "invoices", :force => true do |t|
    t.decimal  "amount"
    t.string   "reason"
    t.datetime "due_by"
    t.boolean  "paid",          :default => false, :null => false
    t.integer  "membership_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.string   "state",        :null => false
    t.decimal  "monthly_fee",  :null => false
    t.datetime "member_since"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id", :unique => true

  create_table "notifications", :force => true do |t|
    t.integer "invoice_id"
    t.string  "cause"
  end

  create_table "payments", :force => true do |t|
    t.decimal  "amount",     :null => false
    t.integer  "invoice_id", :null => false
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",    :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                        :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.text     "bio"
    t.text     "rendered_bio"
    t.string   "full_name"
    t.string   "username"
    t.string   "status"
    t.integer  "roles_mask"
    t.boolean  "display_publicly",                     :default => false
    t.boolean  "receive_notifications",                :default => true
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
