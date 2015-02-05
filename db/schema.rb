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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150205195110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "offers", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_request_id"
  end

  add_index "offers", ["service_request_id"], name: "index_offers_on_service_request_id", using: :btree
  add_index "offers", ["user_id"], name: "index_offers_on_user_id", using: :btree

  create_table "pictures", force: true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.text     "route"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["imageable_id", "imageable_type"], name: "index_pictures_on_imageable_id_and_imageable_type", using: :btree

  create_table "points_transactions", force: true do |t|
    t.integer  "service_arrangement_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points_transactions", ["receiver_id"], name: "index_points_transactions_on_receiver_id", using: :btree
  add_index "points_transactions", ["sender_id"], name: "index_points_transactions_on_sender_id", using: :btree
  add_index "points_transactions", ["service_arrangement_id"], name: "index_points_transactions_on_service_arrangement_id", using: :btree

  create_table "profiles", force: true do |t|
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "service_arrangements", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "client_id"
    t.integer  "server_id"
    t.boolean  "completed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_arrangements", ["client_id", "server_id"], name: "index_service_arrangements_on_client_id_and_server_id", unique: true, using: :btree
  add_index "service_arrangements", ["client_id"], name: "index_service_arrangements_on_client_id", using: :btree
  add_index "service_arrangements", ["server_id"], name: "index_service_arrangements_on_server_id", using: :btree

  create_table "service_requests", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "open",       default: true
  end

  add_index "service_requests", ["user_id"], name: "index_service_requests_on_user_id", using: :btree

  create_table "services", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "serviceable_id"
    t.string   "serviceable_type"
  end

  add_index "services", ["serviceable_id", "serviceable_type"], name: "index_services_on_serviceable_id_and_serviceable_type", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["taggable_id", "taggable_type"], name: "index_tags_on_taggable_id_and_taggable_type", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
