module Csv
  class OpportunityStartDate < PrimaryActiveRecordBase
    self.table_name = 'csv_opportunity_start_dates'

    belongs_to :opportunity, inverse_of: :opportunity_start_dates, optional: true
    has_one :course, through: :opportunity, inverse_of: :opportunity_start_dates

    validates_presence_of :start_date
  end
end
