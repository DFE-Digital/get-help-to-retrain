class ChangeCsvCoursesToCsvCourseLookups < ActiveRecord::Migration[6.0]
  def change
    rename_table :csv_courses, :csv_course_lookups
  end
end
