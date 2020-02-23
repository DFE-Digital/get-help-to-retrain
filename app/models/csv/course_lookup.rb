module Csv
  class CourseLookup < PrimaryActiveRecordBase
    self.table_name = 'csv_course_lookups'

    belongs_to :course_detail, inverse_of: :course_lookups
    belongs_to :addressable, polymorphic: true
  end
end
