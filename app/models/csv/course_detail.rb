module Csv
  class CourseDetail < PrimaryActiveRecordBase
    self.table_name = 'csv_course_details'

    has_one :provider
    has_many :courses
    has_many :opportunities
    has_many :opportunity_start_dates, through: :opportunities, inverse_of: :course_details
    has_many :venues, through: :opportunities, inverse_of: :course_details
  end
end
