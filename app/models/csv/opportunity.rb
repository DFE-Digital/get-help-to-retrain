module Csv
  class Opportunity < PrimaryActiveRecordBase
    self.table_name = 'csv_opportunities'

    belongs_to :course_detail, inverse_of: :opportunities
    belongs_to :venue, inverse_of: :opportunities
    has_one :provider, through: :venue, inverse_of: :opportunities
    has_many :opportunity_start_dates, inverse_of: :opportunity
  end
end
