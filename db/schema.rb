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

ActiveRecord::Schema.define(version: 2020_02_13_130113) do

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

  create_table "coursescsvs", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "provider_id"
    t.text "lad_id"
    t.text "provider_course_title"
    t.text "course_summary"
    t.text "provider_course_id"
    t.text "course_url"
    t.text "booking_url"
    t.text "entry_requirements"
    t.text "assessment_method"
    t.text "equipment_required"
    t.text "qualification_type"
    t.text "qualification_title"
    t.text "qualification_level"
    t.text "ldcs1"
    t.text "ldcs2"
    t.text "ldcs3"
    t.text "ldcs4"
    t.text "ldcs5"
    t.text "data_source"
    t.text "ucas_tariff"
    t.text "qual_ref_authority"
    t.text "qual_reference"
    t.text "course_type_id"
    t.text "date_created"
    t.text "date_updated"
    t.text "status"
    t.text "awarding_org_name"
    t.text "updated_by"
    t.text "created_by"
    t.text "qualification_type_code"
    t.text "data_type"
    t.text "sys_data"
    t.text "date_updated_copy_over"
    t.text "date_created_copy_over"
    t.text "dfe_funded"
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

  create_table "oppa10csvs", force: :cascade do |t|
    t.bigint "opportunity_id"
    t.text "a10_code"
  end

  create_table "opportunitiescsvs", force: :cascade do |t|
    t.bigint "opportunity_id"
    t.text "provider_opportunity_id"
    t.text "price"
    t.text "price_description"
    t.text "duration_value"
    t.text "duration_units"
    t.text "duration_description"
    t.text "start_date_description"
    t.text "end_date"
    t.text "study_mode"
    t.text "attendance_mode"
    t.text "attendance_pattern"
    t.text "language_of_instruction"
    t.text "language_of_assessment"
    t.text "places_available"
    t.text "enquire_to"
    t.text "apply_to"
    t.text "apply_from"
    t.text "apply_until"
    t.text "apply_unti_desc"
    t.text "url"
    t.text "timetable"
    t.bigint "course_id"
    t.bigint "venue_id"
    t.text "apply_throughout_year"
    t.text "eis_flag"
    t.text "region_name"
    t.text "date_created"
    t.text "date_update"
    t.text "status"
    t.text "updated_by"
    t.text "created_by"
    t.text "opportunity_summary"
    t.text "region_id"
    t.text "sys_data_source"
    t.text "date_updated_copy_over"
    t.text "date_created_copy_over"
    t.text "offered_by"
    t.text "dfe_funded"
  end

  create_table "oppstartdatescsvs", force: :cascade do |t|
    t.bigint "opportunity_id"
    t.text "start_date"
    t.text "places_available"
    t.text "date_format"
  end

  create_table "providerscsvs", force: :cascade do |t|
    t.bigint "provider_id"
    t.text "provider_name"
    t.text "ukprn"
    t.text "provider_type_id"
    t.text "provider_type_description"
    t.text "email"
    t.text "website"
    t.text "phone"
    t.text "fax"
    t.text "prov_trading_name"
    t.text "prov_legal_name"
    t.text "lsc_supplier_no"
    t.text "prov_alias"
    t.text "date_created"
    t.text "date_updated"
    t.text "ttg_flag"
    t.text "tqs_flag"
    t.text "ies_flag"
    t.text "status"
    t.text "updated_by"
    t.text "created_by"
    t.text "address_1"
    t.text "address_2"
    t.text "town"
    t.text "county"
    t.text "postcode"
    t.text "sys_data_source"
    t.text "date_updated_copy_over"
    t.text "date_created_copy_over"
    t.text "dfe_provider_type_id"
    t.text "dfe_provider_type_description"
    t.text "dfe_local_authority_code"
    t.text "dfe_local_authority_description"
    t.text "dfe_region_code"
    t.text "dfe_region_description"
    t.text "dfe_establishment_type_code"
    t.text "dfe_establishment_type_description"
    t.index ["provider_id"], name: "provider_idx", unique: true
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

  create_table "slearningaimscsvs", force: :cascade do |t|
    t.text "lara_release_version"
    t.text "lara_download_date"
    t.text "learning_aim_ref"
    t.text "learning_aim_title"
    t.text "learning_aim_type_desc"
    t.text "awarding_body_name"
    t.text "entry_sub_level_desc"
    t.text "notional_level_v2_code"
    t.text "notional_level_v2_desc"
    t.text "credit_based_type_desc"
    t.text "qca_glh"
    t.text "sector_lead_body_desc"
    t.text "level2_entitlement_cat_desc"
    t.text "level3_entitlement_cat_desc"
    t.text "skills_for_life"
    t.text "skills_for_life_type_desc"
    t.text "ssa_tier1_code"
    t.text "ssa_tier1_desc"
    t.text "ssa_tier2_code"
    t.text "ssa_tier2_desc"
    t.text "ldcs_code_code"
    t.text "accreditation_start_date"
    t.text "accreditation_end_date"
    t.text "certification_end_date"
    t.text "ffa_credit"
    t.text "indep_living_skills"
    t.text "er_app_status"
    t.text "er_ttg_status"
    t.text "adultlr_status"
    t.text "otherfunding_nonfundedstatus"
    t.text "learning_aim_type"
    t.text "qual_reference_authority"
    t.text "qualification_reference"
    t.text "qualification_title"
    t.text "qualification_level"
    t.text "qualification_type"
    t.text "date_updated"
    t.text "qualification_type_code"
    t.text "status"
    t.text "qualification_level_code"
    t.text "date_created"
    t.text "source_system_reference"
    t.text "section_96_apprvl_status_code"
    t.text "section_96_apprvl_status_desc"
    t.text "sklls_fundng_apprv_stat_code"
    t.text "sklls_fundng_apprv_stat_desc"
  end

  create_table "venuescsvs", force: :cascade do |t|
    t.bigint "provider_id"
    t.bigint "venue_id"
    t.text "venue_name"
    t.text "prov_venue_id"
    t.text "phone"
    t.text "address_1"
    t.text "address_2"
    t.text "town"
    t.text "county"
    t.text "postcode"
    t.text "email"
    t.text "website"
    t.text "fax"
    t.text "facilities"
  end

end
