class CreateCsvCourseDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :csv_course_details do |t|
      t.bigint :external_course_id
      t.string :name
      t.string :qualification_name
      t.string :qualification_type
      t.string :qualification_level
      t.text   :description
      t.string :url
      t.string :booking_url
      t.timestamps
    end
  end
end
