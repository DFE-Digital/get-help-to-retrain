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

ActiveRecord::Schema.define(version: 2019_06_11_093036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug"
  end

  create_table "categories_job_profiles", force: :cascade do |t|
    t.bigint "job_profile_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_categories_job_profiles_on_category_id"
    t.index ["job_profile_id"], name: "index_categories_job_profiles_on_job_profile_id"
  end

  create_table "job_profiles", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "source_url"
    t.string "description"
    t.boolean "recommended", default: true
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recommended", "name"], name: "index_job_profiles_on_recommended_and_name"
    t.index ["slug"], name: "index_job_profiles_on_slug"
  end

  create_table "job_profiles_skills", force: :cascade do |t|
    t.bigint "job_profile_id"
    t.bigint "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_profile_id"], name: "index_job_profiles_skills_on_job_profile_id"
    t.index ["skill_id"], name: "index_job_profiles_skills_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_skills_on_name"
  end

  add_foreign_key "categories_job_profiles", "categories"
  add_foreign_key "categories_job_profiles", "job_profiles"
  add_foreign_key "job_profiles_skills", "job_profiles"
  add_foreign_key "job_profiles_skills", "skills"
end
