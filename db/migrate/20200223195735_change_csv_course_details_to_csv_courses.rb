class ChangeCsvCourseDetailsToCsvCourses < ActiveRecord::Migration[6.0]
  def change
    rename_table :csv_course_details, :csv_courses

    remove_reference :csv_course_lookups, :course_detail, index: true
    add_reference :csv_course_lookups, :opportunity, index: true

    remove_reference :csv_opportunities, :course_detail, index: true
    add_reference :csv_opportunities, :course, index: true
  end
end
