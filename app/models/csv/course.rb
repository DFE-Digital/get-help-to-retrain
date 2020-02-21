module Csv
  class Course < PrimaryActiveRecordBase
    self.table_name = 'csv_courses'

    belongs_to :course_detail, inverse_of: :courses
    belongs_to :addressable, polymorphic: true
  end
end
