module Csv
  class Venue < PrimaryActiveRecordBase
    self.table_name = 'csv_venues'

    belongs_to :provider, inverse_of: :venues

    has_many :opportunities, inverse_of: :venue
    has_many :course_lookups, as: :addressable
    has_many :courses, through: :opportunities, inverse_of: :venues

    validates_presence_of :external_venue_id, :name, :postcode
  end
end
