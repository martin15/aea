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

ActiveRecord::Schema.define(version: 20160405190732) do

  create_table "countries", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "category_type", limit: 255
    t.string   "permalink",     limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "pick_up_schedules", force: :cascade do |t|
    t.date     "departing_date"
    t.time     "departing_time"
    t.string   "departing_flight_number", limit: 255
    t.string   "departing_airport",       limit: 255
    t.date     "arriving_date"
    t.time     "arriving_time"
    t.string   "arriving_flight_number",  limit: 255
    t.string   "arriving_airport",        limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "user_id",                 limit: 4
  end

  create_table "room_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "room_types_user_types", force: :cascade do |t|
    t.integer  "room_type_id", limit: 4
    t.integer  "user_type_id", limit: 4
    t.integer  "price",        limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "country_type", limit: 200
  end

  create_table "shuttle_buses", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.date     "pick_up_date"
    t.time     "pick_up_time"
    t.string   "airport_name", limit: 255
    t.string   "note",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "user_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "permalink",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "gender",                 limit: 255
    t.integer  "user_type_id",           limit: 4
    t.integer  "country_id",             limit: 4
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "room_type_id",           limit: 4
    t.integer  "price",                  limit: 4,     default: 0
    t.integer  "leader_id",              limit: 4
    t.string   "payment_type",           limit: 255
    t.string   "title",                  limit: 255
    t.string   "passport_number",        limit: 255
    t.string   "roomate",                limit: 255
    t.integer  "age",                    limit: 4
    t.text     "note",                   limit: 65535
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
