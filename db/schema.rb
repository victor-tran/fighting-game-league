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

ActiveRecord::Schema.define(version: 20140501020617) do

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

  create_table "league_posts", force: true do |t|
    t.string   "content"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "league_posts", ["league_id", "created_at"], name: "index_league_posts_on_league_id_and_created_at", using: :btree

  create_table "league_relationships", force: true do |t|
    t.integer  "league_id"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "league_relationships", ["follower_id"], name: "index_league_relationships_on_follower_id", using: :btree
  add_index "league_relationships", ["league_id", "follower_id"], name: "index_league_relationships_on_league_id_and_follower_id", unique: true, using: :btree
  add_index "league_relationships", ["league_id"], name: "index_league_relationships_on_league_id", using: :btree

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
    t.boolean  "playoffs_started"
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
    t.integer  "tournament_id"
  end

  create_table "memberships", force: true do |t|
    t.integer  "league_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "payment_id"
    t.string   "state"
    t.string   "amount"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payment_notifications", force: true do |t|
    t.text     "params"
    t.integer  "user_id"
    t.string   "status"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "amount"
  end

  create_table "posts", force: true do |t|
    t.string   "action"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id"
    t.integer  "match_id"
    t.integer  "bet_id"
  end

  add_index "posts", ["bet_id"], name: "index_posts_on_bet_id", using: :btree
  add_index "posts", ["league_id"], name: "index_posts_on_league_id", using: :btree
  add_index "posts", ["match_id"], name: "index_posts_on_match_id", using: :btree
  add_index "posts", ["postable_id", "postable_type"], name: "index_posts_on_postable_id_and_postable_type", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.integer  "league_id"
    t.integer  "season_number"
    t.string   "participants",       array: true
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "live_image_url"
    t.string   "full_challonge_url"
    t.integer  "game_id"
  end

  create_table "user_posts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_posts", ["user_id", "created_at"], name: "index_user_posts_on_user_id_and_created_at", using: :btree

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
    t.string   "credit_card_id"
    t.string   "credit_card_description"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
