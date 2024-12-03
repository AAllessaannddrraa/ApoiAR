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

ActiveRecord::Schema[7.1].define(version: 2024_12_03_164417) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caregiver_skills", force: :cascade do |t|
    t.bigint "caregiver_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caregiver_id"], name: "index_caregiver_skills_on_caregiver_id"
    t.index ["skill_id"], name: "index_caregiver_skills_on_skill_id"
  end

  create_table "caregivers", force: :cascade do |t|
    t.string "name"
    t.text "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "phone"
    t.integer "support_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_equipments", force: :cascade do |t|
    t.bigint "support_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_support_equipments_on_equipment_id"
    t.index ["support_id"], name: "index_support_equipments_on_support_id"
  end

  create_table "support_skills", force: :cascade do |t|
    t.bigint "support_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_support_skills_on_skill_id"
    t.index ["support_id"], name: "index_support_skills_on_support_id"
  end

  create_table "supports", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "caregiver_id"
    t.index ["caregiver_id"], name: "index_supports_on_caregiver_id"
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "address"
    t.text "notes"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "caregiver_skills", "caregivers"
  add_foreign_key "caregiver_skills", "skills"
  add_foreign_key "support_equipments", "equipment"
  add_foreign_key "support_equipments", "supports"
  add_foreign_key "support_skills", "skills"
  add_foreign_key "support_skills", "supports"
  add_foreign_key "supports", "caregivers"
  add_foreign_key "supports", "users"
end
