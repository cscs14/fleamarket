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

ActiveRecord::Schema.define(version: 2020_01_19_121323) do

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "customer_id", null: false
    t.string "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "category_name", null: false
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliver_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "postal_code", null: false
    t.string "prefecture_id", null: false
    t.string "city", null: false
    t.string "street_address", null: false
    t.string "building_name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_deliver_addresses_on_user_id"
  end

  create_table "freemarkets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item", null: false
    t.integer "price", null: false
    t.string "condition", null: false
    t.string "ship_charge", null: false
    t.string "ship_from", null: false
    t.string "ship_day", null: false
    t.text "description", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_freemarkets_on_user_id"
  end

  create_table "item_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "freemarket_id", null: false
    t.index ["freemarket_id"], name: "index_item_images_on_freemarket_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "freemarket_id"
    t.bigint "deliver_address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deliver_address_id"], name: "index_orders_on_deliver_address_id"
    t.index ["freemarket_id"], name: "index_orders_on_freemarket_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "sns_credentials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sns_credentials_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nickname"
    t.string "email"
    t.string "encrypted_password"
    t.string "last_name"
    t.string "first_name"
    t.string "last_name_kana"
    t.string "first_name_kana"
    t.date "birthday"
    t.string "user_postal_code"
    t.string "user_prefecture"
    t.string "user_city"
    t.string "user_street_address"
    t.string "user_building_name"
    t.string "user_phone"
    t.text "profile_content"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cards", "users"
  add_foreign_key "deliver_addresses", "users"
  add_foreign_key "freemarkets", "users"
  add_foreign_key "item_images", "freemarkets"
  add_foreign_key "orders", "deliver_addresses"
  add_foreign_key "orders", "freemarkets"
  add_foreign_key "orders", "users"
  add_foreign_key "sns_credentials", "users"
end
