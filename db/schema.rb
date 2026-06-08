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

ActiveRecord::Schema[8.1].define(version: 2026_06_08_063644) do
  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "group_id", null: false
    t.integer "kind", null: false
    t.integer "page", null: false
    t.integer "reply_comment_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["group_id"], name: "index_comments_on_group_id"
    t.index ["reply_comment_id"], name: "index_comments_on_reply_comment_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "group_members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "group_id", null: false
    t.integer "role", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["group_id", "user_id"], name: "index_group_members_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "byte_size"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "file_path"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preparation_completions", force: :cascade do |t|
    t.datetime "completed_at", null: false
    t.datetime "created_at", null: false
    t.integer "round_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["round_id", "user_id"], name: "index_preparation_completions_on_round_id_and_user_id", unique: true
    t.index ["round_id"], name: "index_preparation_completions_on_round_id"
    t.index ["user_id"], name: "index_preparation_completions_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "end_page", null: false
    t.integer "group_id", null: false
    t.datetime "held_on"
    t.integer "number", null: false
    t.integer "start_page", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_rounds_on_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "comments", "comments", column: "reply_comment_id"
  add_foreign_key "comments", "groups"
  add_foreign_key "comments", "users"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "users"
  add_foreign_key "preparation_completions", "rounds"
  add_foreign_key "preparation_completions", "users"
  add_foreign_key "rounds", "groups"
end
