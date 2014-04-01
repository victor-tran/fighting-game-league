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

ActiveRecord::Schema.define(version: 20140331200504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bets", force: true do |t|
    t.integer  "match_id"
    t.integer  "better_id"
    t.integer  "favorite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wager_amount"
  end

  create_table "characters", force: true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
  end

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.integer  "commissioner_id"
    t.integer  "game_id"
    t.integer  "current_season_number"
    t.integer  "current_round"
    t.boolean  "started"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_count"
    t.string   "info"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "password_digest"
    t.boolean  "password_protected"
  end

  add_index "leagues", ["commissioner_id"], name: "index_leagues_on_commissioner_id", using: :btree

  create_table "matches", force: true do |t|
    t.datetime "match_date"
    t.integer  "round_number"
    t.integer  "p1_id"
    t.integer  "p2_id"
    t.integer  "p1_score"
    t.integer  "p2_score"
    t.integer  "season_number"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "p1_accepted"
    t.boolean  "p2_accepted"
    t.integer  "game_id"
    t.boolean  "disputed"
    t.datetime "finalized_date"
    t.string   "p1_characters",  default: [], array: true
    t.string   "p2_characters",  default: [], array: true
  end

  create_table "memberships", force: true do |t|
    t.integer  "league_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.integer  "league_id"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "alias"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bio"
    t.string   "tagline"
    t.integer  "fight_bucks"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "facebook_account"
    t.string   "twitter_account"
    t.string   "twitch_account"
    t.string   "uuid"
    t.boolean  "confirmed"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
