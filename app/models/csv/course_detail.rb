class Csv::CourseDetail < PrimaryActiveRecordBase
  self.table_name = 'csv_course_details'

  has_one :provider
end
