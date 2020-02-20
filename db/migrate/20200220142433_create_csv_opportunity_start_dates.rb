class CreateCsvOpportunityStartDates < ActiveRecord::Migration[6.0]
  def change
    create_table :csv_opportunity_start_dates do |t|
      t.belongs_to :opportunity
      t.date :start_date
      t.timestamps
    end
  end
end
