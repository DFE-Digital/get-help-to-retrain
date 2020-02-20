class Csv::Course < PrimaryActiveRecordBase
  self.table_name = 'csv_courses'

  belongs_to :course_detail
  belongs_to :addressable, polymorphic: true
end
