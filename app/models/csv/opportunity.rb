class Csv::Opportunity < PrimaryActiveRecordBase
  self.table_name = 'csv_opportunities'

  belongs_to :course_detail
end
