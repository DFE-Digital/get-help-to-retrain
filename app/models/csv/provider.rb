module Csv
  class Provider < PrimaryActiveRecordBase
    self.table_name = 'csv_providers'

    has_many :course_details, inverse_of: :provider

    has_many :venues, inverse_of: :provider
    has_many :courses, as: :addressable
    has_many :opportunities, through: :venues, inverse_of: :provider
  end
end