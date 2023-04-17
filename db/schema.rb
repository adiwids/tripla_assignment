# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_17_024550) do
  create_table "followings", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.integer "status", limit: 1, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_followings_on_followed_id"
    t.index ["follower_id"], name: "index_followings_on_follower_id"
    t.index ["status"], name: "index_followings_on_status"
  end

  create_table "sleep_cycles", force: :cascade do |t|
    t.integer "user_id"
    t.date "date"
    t.datetime "set_wake_up_time"
    t.datetime "actual_wake_up_time"
    t.integer "duration_seconds"
    t.integer "status", limit: 1, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_sleep_cycles_on_date"
    t.index ["status"], name: "index_sleep_cycles_on_status"
    t.index ["user_id"], name: "index_sleep_cycles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
