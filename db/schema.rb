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

ActiveRecord::Schema.define(version: 2020_06_23_135150) do

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
    t.string "sector"
    t.string "hierarchy"
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
    t.string "master_name"
    t.index ["enabled"], name: "index_skills_on_enabled"
    t.index ["name"], name: "index_skills_on_name"
    t.index ["rarity"], name: "index_skills_on_rarity"
  end

  create_view "skills_plus_variants", sql_definition: <<-SQL
      SELECT skl.id AS variant_skill_id,
      skl.name AS variant_skill_name,
      COALESCE(skv.master_name, skl.name) AS master_skill_name
     FROM (skills skl
       LEFT JOIN skills skv ON (((skl.name)::text = (skv.name)::text)));
  SQL
  create_view "skill_criss_crosses", sql_definition: <<-SQL
      SELECT a.variant_skill_id AS skill_a_id,
      a.variant_skill_name AS skill_a_name,
      b.variant_skill_id AS skill_b_id,
      b.variant_skill_name AS skill_b_name,
      a.master_skill_name
     FROM (skills_plus_variants a
       JOIN skills_plus_variants b ON (((a.master_skill_name)::text = (b.master_skill_name)::text)));
  SQL
end
