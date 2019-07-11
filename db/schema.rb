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

ActiveRecord::Schema.define(version: 2019_07_10_123618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

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
    t.index ["name"], name: "index_skills_on_name"
  end

end
