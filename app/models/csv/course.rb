module Csv
  class Course < PrimaryActiveRecordBase
    self.table_name = 'csv_courses'

    belongs_to :provider, inverse_of: :courses
    has_many :opportunities, inverse_of: :course
    has_many :opportunity_start_dates, through: :opportunities, inverse_of: :course
    has_many :venues, through: :opportunities, inverse_of: :courses
    has_many :course_lookups, through: :opportunities, inverse_of: :course

    validates_presence_of :external_course_id
  end
end
