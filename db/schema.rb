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

ActiveRecord::Schema[8.0].define(version: 2025_03_17_052752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "report_configs", force: :cascade do |t|
    t.string "name"
    t.string "frequency"
    t.string "recipients"
    t.text "prompt"
    t.datetime "last_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "model", default: "gpt-4"
    t.float "temperature", default: 0.7
    t.string "status", default: "draft", null: false
    t.datetime "published_at"
    t.datetime "next_scheduled_at"
    t.integer "user_id"
    t.index ["user_id"], name: "index_report_configs_on_user_id"
  end

  create_table "report_generations", force: :cascade do |t|
    t.bigint "report_config_id", null: false
    t.text "content"
    t.string "status", default: "pending", null: false
    t.text "error_message"
    t.datetime "generated_at"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.index ["generated_at"], name: "index_report_generations_on_generated_at"
    t.index ["report_config_id"], name: "index_report_generations_on_report_config_id"
    t.index ["status"], name: "index_report_generations_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "auth0_id"
    t.string "picture"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth0_id"], name: "index_users_on_auth0_id"
  end

  add_foreign_key "report_generations", "report_configs"
end
