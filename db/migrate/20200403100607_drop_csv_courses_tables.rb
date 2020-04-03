class DropCsvCoursesTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :csv_providers
    drop_table :csv_opportunities
    drop_table :csv_venues
    drop_table :csv_opportunity_start_dates
    drop_table :csv_courses
    drop_table :csv_course_lookups
    drop_table :courses
  end
end
