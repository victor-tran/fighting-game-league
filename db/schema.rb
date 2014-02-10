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

ActiveRecord::Schema.define(version: 20140209203726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "memberships", force: true do |t|
    t.integer  "league_id"
    t.integer  "user_id"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
