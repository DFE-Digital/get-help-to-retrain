class Csv::Venue < PrimaryActiveRecordBase
  self.table_name = 'csv_venues'

  belongs_to :provider

  has_many :opportunities
  has_many :course_details, through: :opportunities, inverse_of: :venues
end
