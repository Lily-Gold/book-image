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

ActiveRecord::Schema[8.0].define(version: 2025_11_01_123045) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title", limit: 120, null: false
    t.string "author", limit: 100, default: "", null: false
    t.string "publisher", limit: 100, default: "", null: false
    t.date "published_on"
    t.string "isbn", limit: 20
    t.string "google_books_id", limit: 80
    t.text "description"
    t.string "cover_url", limit: 500
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_books_id"], name: "index_books_on_google_books_id", unique: true
    t.index ["isbn"], name: "index_books_on_isbn"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "image_tags", force: :cascade do |t|
    t.string "name", limit: 10, null: false
    t.string "color", limit: 7, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_image_tags_on_name", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.bigint "image_tag_id", null: false
    t.text "content", null: false
    t.boolean "is_spoiler", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["image_tag_id"], name: "index_reviews_on_image_tag_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "introduction", limit: 200
    t.string "avatar_url", limit: 500, default: "avatar.png"
    t.string "provider", limit: 50
    t.string "uid", limit: 100
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "books", "users"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "image_tags"
  add_foreign_key "reviews", "users"
end
