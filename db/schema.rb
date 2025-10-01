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

ActiveRecord::Schema[8.0].define(version: 2025_09_30_190408) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "goals", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "human_resources", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "zone_id", null: false
    t.bigint "speciality_id", null: false
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_human_resources_on_provider_id"
    t.index ["speciality_id"], name: "index_human_resources_on_speciality_id"
    t.index ["zone_id"], name: "index_human_resources_on_zone_id"
  end

  create_table "prices", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provider_appointments", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.integer "year"
    t.string "period"
    t.string "means"
    t.string "reminder"
    t.string "withdraw"
    t.string "communication"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_provider_appointments_on_provider_id"
  end

  create_table "provider_data", force: :cascade do |t|
    t.integer "year"
    t.string "period"
    t.integer "fonasa_users"
    t.integer "no_fonasa_users"
    t.integer "total"
    t.bigint "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_provider_data_on_provider_id"
  end

  create_table "provider_goals", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "goal_id", null: false
    t.integer "year"
    t.string "period"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_provider_goals_on_goal_id"
    t.index ["provider_id"], name: "index_provider_goals_on_provider_id"
  end

  create_table "provider_prices", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "price_id", null: false
    t.boolean "fonasa"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.text "period"
    t.index ["price_id"], name: "index_provider_prices_on_price_id"
    t.index ["provider_id"], name: "index_provider_prices_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.integer "external_id"
    t.string "short_name"
    t.string "name"
    t.string "web"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
  end

  create_table "specialities", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specialties", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wait_times", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "speciality_id", null: false
    t.integer "wtype"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.text "period"
    t.index ["provider_id"], name: "index_wait_times_on_provider_id"
    t.index ["speciality_id"], name: "index_wait_times_on_speciality_id"
  end

  create_table "zones", force: :cascade do |t|
    t.string "name"
    t.integer "ztype"
    t.text "wkt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "human_resources", "providers"
  add_foreign_key "human_resources", "specialities"
  add_foreign_key "human_resources", "zones"
  add_foreign_key "provider_appointments", "providers"
  add_foreign_key "provider_data", "providers"
  add_foreign_key "provider_goals", "goals"
  add_foreign_key "provider_goals", "providers"
  add_foreign_key "provider_prices", "prices"
  add_foreign_key "provider_prices", "providers"
  add_foreign_key "wait_times", "providers"
  add_foreign_key "wait_times", "specialities"
end
