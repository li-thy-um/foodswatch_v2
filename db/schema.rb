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

ActiveRecord::Schema.define(version: 20150217223024) do

  create_table "foods", force: true do |t|
    t.string   "name",       limit: nil
    t.integer  "weight"
    t.integer  "prot"
    t.integer  "carb"
    t.integer  "fat"
    t.integer  "calorie"
    t.string   "info",       limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "status",     limit: nil
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "microposts", force: true do |t|
    t.string   "content",       limit: nil
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "original_id"
    t.integer  "comment_id"
    t.integer  "shared_id"
    t.integer  "share_count",               default: 0
    t.integer  "post_food_id"
    t.integer  "comment_count",             default: 0
  end

  add_index "microposts", ["comment_id"], name: "index_microposts_on_comment_id"
  add_index "microposts", ["original_id"], name: "index_microposts_on_original_id"
  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"

  create_table "post_food_relationships", force: true do |t|
    t.integer  "post_id"
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_food_relationships", ["food_id"], name: "index_post_food_relationships_on_food_id"
  add_index "post_food_relationships", ["post_id"], name: "index_post_food_relationships_on_post_id"

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: true do |t|
    t.string   "name",            limit: nil
    t.string   "email",           limit: nil
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", limit: nil
    t.string   "remember_token",  limit: nil
    t.boolean  "admin",                       default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "watches", force: true do |t|
    t.integer  "user_id"
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watches", ["food_id"], name: "index_watches_on_food_id"
  add_index "watches", ["user_id"], name: "index_watches_on_user_id"

end
