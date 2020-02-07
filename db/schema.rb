# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_06_145253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "title", null: false
    t.string "provider", null: false
    t.string "url", null: false
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "town"
    t.string "county"
    t.string "postcode", null: false
    t.string "email"
    t.string "topic", null: false
    t.string "phone_number"
    t.boolean "active", default: false
    t.float "latitude", default: 0.0, null: false
    t.float "longitude", default: 0.0, null: false
    t.index ["longitude", "latitude"], name: "index_courses_on_longitude_and_latitude"
    t.index ["postcode"], name: "index_courses_on_postcode"
    t.index ["topic"], name: "index_courses_on_topic"
  end

  create_table "job_profile_categories", force: :cascade do |t|
    t.bigint "job_profile_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_job_profile_categories_on_category_id"
    t.index ["job_profile_id"], name: "index_job_profile_categories_on_job_profile_id"
  end

  create_table "job_profile_skills", force: :cascade do |t|
    t.bigint "job_profile_id"
    t.bigint "skill_id"
    t.boolean "required", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_profile_id"], name: "index_job_profile_skills_on_job_profile_id"
    t.index ["skill_id"], name: "index_job_profile_skills_on_skill_id"
  end

  create_table "job_profiles", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "source_url"
    t.string "description"
    t.boolean "recommended", default: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "salary_min"
    t.integer "salary_max"
    t.string "alternative_titles"
    t.string "soc"
    t.string "extended_soc"
    t.decimal "growth"
    t.string "hidden_titles"
    t.string "specialism"
    t.index "to_tsvector('english'::regconfig, (alternative_titles)::text)", name: "job_profiles_alternative_titles_idx", using: :gin
    t.index "to_tsvector('english'::regconfig, (description)::text)", name: "job_profiles_description_idx", using: :gin
    t.index "to_tsvector('english'::regconfig, (name)::text)", name: "job_profiles_name_idx", using: :gin
    t.index ["slug"], name: "index_job_profiles_on_slug", unique: true
  end

  create_table "related_job_profiles", id: false, force: :cascade do |t|
    t.integer "job_profile_id"
    t.integer "related_job_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_profile_id"], name: "index_related_job_profiles_on_job_profile_id"
    t.index ["related_job_profile_id"], name: "index_related_job_profiles_on_related_job_profile_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true, null: false
    t.integer "rarity"
    t.index ["enabled"], name: "index_skills_on_enabled"
    t.index ["name"], name: "index_skills_on_name"
    t.index ["rarity"], name: "index_skills_on_rarity"
  end

  create_table "v2_job_profile_skills", force: :cascade do |t|
    t.bigint "v2_job_profile_id"
    t.bigint "v2_skill_id"
    t.boolean "required", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["v2_job_profile_id"], name: "index_v2_job_profile_skills_on_v2_job_profile_id"
    t.index ["v2_skill_id"], name: "index_v2_job_profile_skills_on_v2_skill_id"
  end

  create_table "v2_job_profiles", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "source_url"
    t.string "description"
    t.boolean "recommended", default: false
    t.jsonb "content", default: "{}", null: false
    t.datetime "last_updated"
    t.integer "salary_min"
    t.integer "salary_max"
    t.string "alternative_titles"
    t.string "soc"
    t.string "onet_occupation_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_v2_job_profiles_on_slug", unique: true
  end

  create_table "v2_skills", force: :cascade do |t|
    t.string "name"
    t.decimal "onet_rank"
    t.string "onet_element_id"
    t.string "onet_attribute_type"
    t.string "level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_v2_skills_on_name"
  end

end
