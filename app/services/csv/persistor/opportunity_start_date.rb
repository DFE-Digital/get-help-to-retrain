module Csv
  module Persistor
    class OpportunityStartDate
      FILENAME = 'O_OPP_START_DATES.csv'.freeze

      attr_reader :row

      def initialize(row)
        @row = row
      end

      def persist!
        Csv::OpportunityStartDate.create!(
          start_date: row['START_DATE'],
          opportunity: opportunity
        )
      end

      private

      def opportunity
        Csv::Opportunity.find_by(external_opportunities_id: row['OPPORTUNITY_ID'])
      end
    end
  end
end
