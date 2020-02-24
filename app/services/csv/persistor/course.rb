module Csv
  module Persistor
    class Course
      FILENAME = 'O_COURSES.csv'.freeze

      attr_reader :path

      def initialize(folder)
        @path = File.join(folder, FILENAME)
      end

      def persist!
        CSV.foreach(path, headers: true) do |row|
          Csv::Course.create!(
            attributes_for(row)
          )
        end
      end

      private

      def attributes_for(row) # rubocop:disable Metrics/MethodLength
        {
          external_course_id: row['COURSE_ID'],
          name: row['PROVIDER_COURSE_TITLE'],
          qualification_name: row['QUALIFICATION_TITLE'],
          qualification_type: row['QUALIFICATION_TYPE'],
          qualification_level: row['QUALIFICATION_LEVEL'],
          description: row['COURSE_SUMMARY'],
          url: row['COURSE_URL'],
          booking_url: row['BOOKING_URL'],
          provider: Csv::Provider.find_by(external_provider_id: row['PROVIDER_ID'])
        }
      end
    end
  end
end
