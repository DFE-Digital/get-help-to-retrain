class Csv::Provider < PrimaryActiveRecordBase
  self.table_name = 'csv_providers'

  belongs_to :course_detail
end
