class CreateOpportunitiescsvs < ActiveRecord::Migration[6.0]
  def change
    create_table :opportunitiescsvs do |t|
      t.text :opportunity_id
      t.text :provider_opportunity_id
      t.text :price
      t.text :price_description
      t.text :duration_value
      t.text :duration_units
      t.text :duration_description
      t.text :start_date_description
      t.text :end_date
      t.text :study_mode
      t.text :attendance_mode
      t.text :attendance_pattern
      t.text :language_of_instruction
      t.text :language_of_assessment
      t.text :places_available
      t.text :enquire_to
      t.text :apply_to
      t.text :apply_from
      t.text :apply_until
      t.text :apply_unti_desc
      t.text :url
      t.text :timetable
      t.text :course_id
      t.text :venue_id
      t.text :apply_throughout_year
      t.text :eis_flag
      t.text :region_name
      t.text :date_created
      t.text :date_update
      t.text :status
      t.text :updated_by
      t.text :created_by
      t.text :opportunity_summary
      t.text :region_id
      t.text :sys_data_source
      t.text :date_updated_copy_over
      t.text :date_created_copy_over
      t.text :offered_by
      t.text :dfe_funded
    end
  end
end
