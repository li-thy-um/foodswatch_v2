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

ActiveRecord::Schema.define(version: 20150604062028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "foods", force: :cascade do |t|
    t.string   "name"
    t.integer  "weight"
    t.integer  "prot"
    t.integer  "carb"
    t.integer  "fat"
    t.integer  "calorie"
    t.string   "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "micropost_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["micropost_id"], name: "index_likes_on_micropost_id", using: :btree
  add_index "likes", ["user_id", "micropost_id"], name: "index_likes_on_user_id_and_micropost_id", unique: true, using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "original_id"
    t.integer  "comment_id"
    t.integer  "shared_id"
    t.integer  "share_count",   default: 0
    t.integer  "post_food_id"
    t.integer  "comment_count", default: 0
  end

  add_index "microposts", ["comment_id"], name: "index_microposts_on_comment_id", using: :btree
  add_index "microposts", ["original_id"], name: "index_microposts_on_original_id", using: :btree
  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "notices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "target_post_id"
    t.integer  "action_post_id"
    t.boolean  "read",           default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "notice_type"
    t.integer  "action_user_id"
  end

  add_index "notices", ["read"], name: "index_notices_on_read", using: :btree
  add_index "notices", ["user_id", "read"], name: "index_notices_on_user_id_and_read", using: :btree
  add_index "notices", ["user_id"], name: "index_notices_on_user_id", using: :btree

  create_table "post_food_relationships", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_food_relationships", ["food_id"], name: "index_post_food_relationships_on_food_id", using: :btree
  add_index "post_food_relationships", ["post_id"], name: "index_post_food_relationships_on_post_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                    default: false
    t.boolean  "email_confirmed"
    t.string   "email_confirmation_token", default: ""
    t.string   "change_password_token"
    t.datetime "change_password_at"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["email_confirmation_token"], name: "index_users_on_email_confirmation_token", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "watches", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watches", ["food_id"], name: "index_watches_on_food_id", using: :btree
  add_index "watches", ["user_id"], name: "index_watches_on_user_id", using: :btree

end
