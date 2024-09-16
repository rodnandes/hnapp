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

ActiveRecord::Schema[7.2].define(version: 2024_09_16_022913) do
  create_table "comments", force: :cascade do |t|
    t.string "by"
    t.datetime "time"
    t.text "text"
    t.integer "hn_id"
    t.integer "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.index ["hn_id"], name: "index_comments_on_hn_id", unique: true
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["story_id"], name: "index_comments_on_story_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "by"
    t.datetime "time"
    t.text "text"
    t.string "url"
    t.integer "score"
    t.string "title"
    t.integer "comment_count"
    t.integer "hn_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hn_id"], name: "index_stories_on_hn_id", unique: true
  end

  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "stories"
end
