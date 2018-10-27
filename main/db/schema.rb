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

ActiveRecord::Schema.define(version: 2018_09_18_111510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "root_category_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "eng"
    t.string "jpn"
    t.index ["root_category_id"], name: "index_categories_on_root_category_id"
  end

  create_table "item_match_ships", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "match_id"
    t.integer "quantity"
    t.string "unit", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_match_ships_on_item_id"
    t.index ["match_id"], name: "index_item_match_ships_on_match_id"
  end

  create_table "item_section_ships", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_section_ships_on_item_id"
    t.index ["section_id"], name: "index_item_section_ships_on_section_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name"
    t.text "detail"
    t.integer "stock"
    t.string "stock_unit", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "eng"
    t.string "jpn"
    t.text "eng_detail"
    t.text "jpn_detail"
    t.integer "price", default: 0
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "match_section_ships", force: :cascade do |t|
    t.bigint "match_id"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_section_ships_on_match_id"
    t.index ["section_id"], name: "index_match_section_ships_on_section_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name"
    t.text "detail"
    t.string "how_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "eng"
    t.string "jpn"
    t.text "eng_detail"
    t.text "jpn_detail"
    t.string "eng_how_to"
    t.string "jpn_how_to"
    t.integer "price", default: 0
    t.index ["category_id"], name: "index_matches_on_category_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "root_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "menu_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "eng"
    t.string "jpn"
    t.index ["menu_id"], name: "index_sections_on_menu_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "match_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_tags_on_item_id"
    t.index ["match_id"], name: "index_tags_on_match_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "categories", "root_categories"
  add_foreign_key "item_match_ships", "items"
  add_foreign_key "item_match_ships", "matches"
  add_foreign_key "item_section_ships", "items"
  add_foreign_key "item_section_ships", "sections"
  add_foreign_key "items", "categories"
  add_foreign_key "match_section_ships", "matches"
  add_foreign_key "match_section_ships", "sections"
  add_foreign_key "matches", "categories"
  add_foreign_key "sections", "menus"
  add_foreign_key "tags", "items"
  add_foreign_key "tags", "matches"
end
