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

ActiveRecord::Schema.define(version: 2018_06_10_055037) do

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "root_categories_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["root_categories_id"], name: "index_categories_on_root_categories_id"
  end

  create_table "item_match_ships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "items_id"
    t.bigint "matches_id"
    t.integer "quantity"
    t.string "unit", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["items_id"], name: "index_item_match_ships_on_items_id"
    t.index ["matches_id"], name: "index_item_match_ships_on_matches_id"
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "categories_id"
    t.bigint "sections_id"
    t.string "name"
    t.text "detail"
    t.integer "stock"
    t.string "stock_unit", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categories_id"], name: "index_items_on_categories_id"
    t.index ["sections_id"], name: "index_items_on_sections_id"
  end

  create_table "matches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "categories_id"
    t.bigint "sections_id"
    t.string "name"
    t.text "detail"
    t.string "how_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categories_id"], name: "index_matches_on_categories_id"
    t.index ["sections_id"], name: "index_matches_on_sections_id"
  end

  create_table "menus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "root_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "menus_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menus_id"], name: "index_sections_on_menus_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "items_id"
    t.bigint "matches_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["items_id"], name: "index_tags_on_items_id"
    t.index ["matches_id"], name: "index_tags_on_matches_id"
  end

  add_foreign_key "categories", "root_categories", column: "root_categories_id"
  add_foreign_key "item_match_ships", "items", column: "items_id"
  add_foreign_key "item_match_ships", "matches", column: "matches_id"
  add_foreign_key "items", "categories", column: "categories_id"
  add_foreign_key "items", "sections", column: "sections_id"
  add_foreign_key "matches", "categories", column: "categories_id"
  add_foreign_key "matches", "sections", column: "sections_id"
  add_foreign_key "sections", "menus", column: "menus_id"
  add_foreign_key "tags", "items", column: "items_id"
  add_foreign_key "tags", "matches", column: "matches_id"
end
