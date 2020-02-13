class CreateSlearningaimscsvs < ActiveRecord::Migration[6.0]
  def change
    create_table :slearningaimscsvs do |t|
      t.text :lara_release_version
      t.text :lara_download_date
      t.text :learning_aim_ref
      t.text :learning_aim_title
      t.text :learning_aim_type_desc
      t.text :awarding_body_name
      t.text :entry_sub_level_desc
      t.text :notional_level_v2_code
      t.text :notional_level_v2_desc
      t.text :credit_based_type_desc
      t.text :qca_glh
      t.text :sector_lead_body_desc
      t.text :level2_entitlement_cat_desc
      t.text :level3_entitlement_cat_desc
      t.text :skills_for_life
      t.text :skills_for_life_type_desc
      t.text :ssa_tier1_code
      t.text :ssa_tier1_desc
      t.text :ssa_tier2_code
      t.text :ssa_tier2_desc
      t.text :ldcs_code_code
      t.text :accreditation_start_date
      t.text :accreditation_end_date
      t.text :certification_end_date
      t.text :ffa_credit
      t.text :indep_living_skills
      t.text :er_app_status
      t.text :er_ttg_status
      t.text :adultlr_status
      t.text :otherfunding_nonfundedstatus
      t.text :learning_aim_type
      t.text :qual_reference_authority
      t.text :qualification_reference
      t.text :qualification_title
      t.text :qualification_level
      t.text :qualification_type
      t.text :date_updated
      t.text :qualification_type_code
      t.text :status
      t.text :qualification_level_code
      t.text :date_created
      t.text :source_system_reference
      t.text :section_96_apprvl_status_code
      t.text :section_96_apprvl_status_desc
      t.text :sklls_fundng_apprv_stat_code
      t.text :sklls_fundng_apprv_stat_desc
    end
  end
end
