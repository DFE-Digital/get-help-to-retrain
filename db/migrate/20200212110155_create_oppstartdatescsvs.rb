class CreateOppstartdatescsvs < ActiveRecord::Migration[6.0]
  def change
    create_table :oppstartdatescsvs do |t|
      t.text :opportunity_id
      t.text :start_date
      t.text :places_available
      t.text :date_format
    end
  end
end
