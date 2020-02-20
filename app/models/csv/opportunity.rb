class Csv::Opportunity < PrimaryActiveRecordBase
  self.table_name = 'csv_opportunities'

  belongs_to :course_detail
  belongs_to :venue
  has_many :opportunity_start_dates
end
