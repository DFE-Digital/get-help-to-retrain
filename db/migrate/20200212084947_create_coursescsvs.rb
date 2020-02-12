class CreateCoursescsvs < ActiveRecord::Migration[6.0]
  def change
    create_table :coursescsvs do |t|
      t.text :course_id
      t.text :provider_id
      t.text :lad_id
      t.text :provider_course_title
      t.text :course_summary
      t.text :provider_course_id
      t.text :course_url
      t.text :booking_url
      t.text :entry_requirements
      t.text :assessment_method
      t.text :equipment_required
      t.text :qualification_type
      t.text :qualification_title
      t.text :qualification_level
      t.text :ldcs1
      t.text :ldcs2
      t.text :ldcs3
      t.text :ldcs4
      t.text :ldcs5
      t.text :data_source
      t.text :ucas_tariff
      t.text :qual_ref_authority
      t.text :qual_reference
      t.text :course_type_id
      t.text :date_created
      t.text :date_updated
      t.text :status
      t.text :awarding_org_name
      t.text :updated_by
      t.text :created_by
      t.text :qualification_type_code
      t.text :data_type
      t.text :sys_data
      t.text :date_updated_copy_over
      t.text :date_created_copy_over
      t.text :dfe_funded
    end
  end
end
