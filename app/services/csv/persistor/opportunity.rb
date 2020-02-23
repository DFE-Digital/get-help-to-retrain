module Csv
  module Persistor
    class Opportunity
      FILENAME = 'O_OPPORTUNITIES.csv'.freeze

      attr_reader :path

      def initialize(folder)
        @path = File.join(folder, FILENAME)
      end

      def persist!
        CSV.foreach(path, headers: true) do |row|
          next if Csv::Venue.find_by(external_venue_id: row['VENUE_ID']).nil?

          Csv::Opportunity.create!(
            external_opportunities_id: row['OPPORTUNITY_ID'],
            attendance_modes: row['ATTENDANCE_MODES'],
            attendance_pattern: row['ATTENDANCE_PATTERN'],
            study_modes: row['STUDY_MODES'],
            end_date: row['END_DATE'],
            duration_value: row['DURATION_VALUE'],
            duration_type: row['DURATION_TYPE'],
            duration_description: row['DURATION_DESCRIPTION'],
            start_date_description: row['START_DATE_DESCRIPTION'],
            price: row['PRICE'],
            price_description: row['PRICE_DESCRIPTION'],
            url: row['URL'],
            venue: Csv::Venue.find_by(external_venue_id: row['VENUE_ID']),
            course_detail: Csv::CourseDetail.find_by(external_course_id: row['COURSE_ID'])
          )
        end
      end
    end
  end
end
