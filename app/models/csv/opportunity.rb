module Csv
  class Opportunity < PrimaryActiveRecordBase
    self.table_name = 'csv_opportunities'

    belongs_to :course, inverse_of: :opportunities
    belongs_to :venue, inverse_of: :opportunities, optional: true
    has_one :provider, through: :venue, inverse_of: :opportunities
    has_many :course_lookups, inverse_of: :opportunity
    has_many :opportunity_start_dates, inverse_of: :opportunity

    validates_presence_of :external_opportunities_id
  end
end
