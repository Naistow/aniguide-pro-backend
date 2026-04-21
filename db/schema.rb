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

ActiveRecord::Schema[8.1].define(version: 2026_04_10_110856) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "appearances", force: :cascade do |t|
    t.integer "character_id", null: false
    t.datetime "created_at", null: false
    t.string "episodes"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false
    t.index ["character_id"], name: "index_appearances_on_character_id"
    t.index ["work_id"], name: "index_appearances_on_work_id"
  end

  create_table "character_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.text "backstory"
    t.text "biography"
    t.integer "character_role_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "franchise_id", null: false
    t.text "history"
    t.string "name"
    t.string "photo_url"
    t.text "plot_role"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["character_role_id"], name: "index_characters_on_character_role_id"
    t.index ["franchise_id"], name: "index_characters_on_franchise_id"
  end

  create_table "characters_episodes", id: false, force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "episode_id", null: false
  end

  create_table "episode_appearances", force: :cascade do |t|
    t.integer "character_id", null: false
    t.datetime "created_at", null: false
    t.integer "episode_id", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_episode_appearances_on_character_id"
    t.index ["episode_id"], name: "index_episode_appearances_on_episode_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "duration"
    t.integer "episode_number"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "work_id", null: false
    t.index ["work_id"], name: "index_episodes_on_work_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "work_id"
    t.index ["character_id"], name: "index_favorites_on_character_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "franchises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.string "theme"
    t.datetime "updated_at", null: false
  end

  create_table "glossaries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "franchise_id", null: false
    t.string "image_url"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_glossaries_on_franchise_id"
  end

  create_table "guide_steps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "editor_note"
    t.integer "step_number"
    t.datetime "updated_at", null: false
    t.integer "watch_guide_id", null: false
    t.integer "work_id", null: false
    t.index ["watch_guide_id"], name: "index_guide_steps_on_watch_guide_id"
    t.index ["work_id"], name: "index_guide_steps_on_work_id"
  end

  create_table "lore_glossaries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "definition"
    t.integer "franchise_id", null: false
    t.string "term"
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_lore_glossaries_on_franchise_id"
  end

  create_table "media_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "franchise_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["franchise_id"], name: "index_reviews_on_franchise_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "user_progresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "work_id", null: false
    t.index ["user_id"], name: "index_user_progresses_on_user_id"
    t.index ["work_id"], name: "index_user_progresses_on_work_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role_name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.integer "user_role_id", null: false
    t.string "username"
    t.index ["user_role_id"], name: "index_users_on_user_role_id"
  end

  create_table "watch_guides", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "franchise_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_watch_guides_on_franchise_id"
  end

  create_table "works", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "franchise_id", null: false
    t.string "image_url"
    t.integer "media_type_id", null: false
    t.integer "parent_id"
    t.text "plot_summary"
    t.integer "pos_x"
    t.integer "pos_y"
    t.string "poster_url"
    t.integer "release_year"
    t.text "synopsis"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["franchise_id"], name: "index_works_on_franchise_id"
    t.index ["media_type_id"], name: "index_works_on_media_type_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "appearances", "characters"
  add_foreign_key "appearances", "works"
  add_foreign_key "characters", "character_roles"
  add_foreign_key "characters", "franchises"
  add_foreign_key "episode_appearances", "characters"
  add_foreign_key "episode_appearances", "episodes"
  add_foreign_key "episodes", "works"
  add_foreign_key "favorites", "characters"
  add_foreign_key "favorites", "users"
  add_foreign_key "glossaries", "franchises"
  add_foreign_key "guide_steps", "watch_guides"
  add_foreign_key "guide_steps", "works"
  add_foreign_key "lore_glossaries", "franchises"
  add_foreign_key "reviews", "franchises"
  add_foreign_key "reviews", "users"
  add_foreign_key "user_progresses", "users"
  add_foreign_key "user_progresses", "works"
  add_foreign_key "users", "user_roles"
  add_foreign_key "watch_guides", "franchises"
  add_foreign_key "works", "franchises"
  add_foreign_key "works", "media_types"
end
