class CreateCsvOpportunities < ActiveRecord::Migration[6.0]
  def change
    create_table :csv_opportunities do |t|
      t.belongs_to :course_detail
      t.belongs_to :venue
      t.bigint :external_opportunities_id
      t.string :attendance_modes
      t.string :attendance_pattern
      t.string :study_modes
      t.date   :end_date
      t.integer :duration_value
      t.string :duration_type
      t.text :duration_description
      t.text :start_date_description
      t.float :price, precision: 2
      t.text :price_description
      t.string :url
      t.timestamps
    end
  end
end
