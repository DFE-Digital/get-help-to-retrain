module Csv
  class Provider < PrimaryActiveRecordBase
    self.table_name = 'csv_providers'

    belongs_to :course_detail
    has_many :courses, as: :addressable
  end
end
