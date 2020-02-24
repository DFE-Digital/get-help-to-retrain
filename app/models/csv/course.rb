module Csv
  class Course < PrimaryActiveRecordBase
    self.table_name = 'csv_courses'

    belongs_to :provider, inverse_of: :courses
    has_many :opportunities, inverse_of: :course
    has_many :opportunity_start_dates, through: :opportunities, inverse_of: :course
    has_many :venues, through: :opportunities, inverse_of: :courses
  end
end
