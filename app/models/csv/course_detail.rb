module Csv
  class CourseDetail < PrimaryActiveRecordBase
    self.table_name = 'csv_course_details'

    belongs_to :provider, inverse_of: :course_details
    has_many :courses, inverse_of: :course_detail
    has_many :opportunities, inverse_of: :course_detail
    has_many :opportunity_start_dates, through: :opportunities, inverse_of: :course_detail
    has_many :venues, through: :opportunities, inverse_of: :course_details
  end
end
