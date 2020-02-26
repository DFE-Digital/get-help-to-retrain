module Csv
  class Provider < PrimaryActiveRecordBase
    self.table_name = 'csv_providers'

    has_many :courses, inverse_of: :provider

    has_many :venues, inverse_of: :provider
    has_many :course_lookups, as: :addressable
    has_many :opportunities, through: :venues, inverse_of: :provider

    validates_presence_of :external_provider_id, :name, :postcode
  end
end
