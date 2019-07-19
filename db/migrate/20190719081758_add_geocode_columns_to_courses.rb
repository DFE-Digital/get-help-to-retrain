class AddGeocodeColumnsToCourses < ActiveRecord::Migration[5.2]
  def up
    change_column :courses, :postcode, :string, null: false
    add_column :courses, :latitude, :float, default: 0.0, null: false
    add_column :courses, :longitude, :float, default: 0.0, null: false

    add_index :courses, :postcode
    add_index :courses, [:longitude, :latitude]
  end

  def down
    change_column :courses, :postcode, :string, null: true
    remove_column :courses, :latitude
    remove_column :courses, :longitude

    remove_index :courses, name: 'index_courses_on_postcode'
  end
end
