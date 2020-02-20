class CreateCsvCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :csv_courses do |t|
      t.belongs_to :course_detail
      t.references :addressable, polymorphic: true

      t.string :subject
      t.string :hours
      t.string :delivery_type
      t.string :postcode
      t.float :latitude, default: 0.0, null: false
      t.float :longitude, default: 0.0, null: false
    end

    add_index :csv_courses, [:longitude, :latitude]
  end
end
