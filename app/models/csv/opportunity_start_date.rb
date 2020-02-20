class Csv::OpportunityStartDate < PrimaryActiveRecordBase
  self.table_name = 'csv_opportunity_start_dates'

  belongs_to :opportunity
end
