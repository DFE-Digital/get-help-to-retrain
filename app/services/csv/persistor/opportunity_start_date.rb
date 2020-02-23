module Csv
  module Persistor
    class OpportunityStartDate
      FILENAME = 'O_OPP_START_DATES.csv'.freeze

      attr_reader :path

      def initialize(folder)
        @path = File.join(folder, FILENAME)
      end

      def persist!
        CSV.foreach(path, headers: true) do |row|
          Csv::OpportunityStartDate.create!(
            start_date: row['START_DATE']
            opportunity: Csv::Opportunity.find_by(external_opportunity_id: row['OPPORTUNITY_ID'])
          )
        end
      end
    end
  end
end
