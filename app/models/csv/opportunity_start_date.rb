module Csv
  class OpportunityStartDate < PrimaryActiveRecordBase
    self.table_name = 'csv_opportunity_start_dates'

    belongs_to :opportunity, inverse_of: :opportunity_start_dates
    has_one :course, through: :opportunity, inverse_of: :opportunity_start_dates
  end
end
