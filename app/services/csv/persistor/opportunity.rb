module Csv
  module Persistor
    class Opportunity
      FILENAME = 'O_OPPORTUNITIES.csv'.freeze

      attr_reader :row

      def initialize(row)
        @row = row
      end

      def persist! # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        Csv::Opportunity.create!(
          external_opportunities_id: row['OPPORTUNITY_ID'],
          attendance_modes: attendance_mode,
          attendance_pattern: attendance_pattern,
          study_modes: study_mode,
          end_date: row['END_DATE'],
          duration_value: row['DURATION_VALUE'],
          duration_type: duration_units,
          duration_description: row['DURATION_DESCRIPTION'],
          start_date_description: row['START_DATE_DESCRIPTION'],
          price: row['PRICE'],
          price_description: row['PRICE_DESCRIPTION'],
          url: row['URL'],
          venue: venue,
          course: course
        )
      end

      private

      def course
        Csv::Course.find_by(external_course_id: row['COURSE_ID'])
      end

      def venue
        Csv::Venue.find_by(external_venue_id: row['VENUE_ID'])
      end

      def study_mode # rubocop:disable Metrics/CyclomaticComplexity
        return unless row['STUDY_MODE']

        case row['STUDY_MODE']
        when 'SM1' then 'Full time'
        when 'SM2' then 'Part time'
        when 'SM3' then 'Part of a full-time program'
        when 'SM4' then 'Flexible'
        when 'SM5' then 'Not known'
        else 'No matching value'
        end
      end

      def attendance_mode # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        return unless row['ATTENDANCE_MODE']

        case row['ATTENDANCE_MODE']
        when 'AM1' then 'Location / campus'
        when 'AM2' then 'Face-to-face (non-campus)'
        when 'AM3' then 'Work-based'
        when 'AM4' then 'Mixed Mode'
        when 'AM5' then 'Distance with attendance'
        when 'AM6' then 'Distance without attendance'
        when 'AM7' then 'Online without attendance'
        when 'AM8' then 'Online with attendance'
        when 'AM9' then 'Not known'
        else 'No matching value'
        end
      end

      def attendance_pattern # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        return unless row['ATTENDANCE_PATTERN']

        case row['ATTENDANCE_PATTERN']
        when 'AP1' then 'Daytime/working hours'
        when 'AP2' then 'Day/Block release'
        when 'AP3' then 'Evening'
        when 'AP4' then 'Twilight'
        when 'AP5' then 'Weekend'
        when 'AP6' then 'Customised'
        when 'AP7' then 'Not known'
        when 'AP8' then 'Not applicable'
        else 'No matching value'
        end
      end

      def duration_units # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        return unless row['DURATION_UNITS']

        case row['DURATION_UNITS']
        when 'DU1' then 'Hour'
        when 'DU2' then 'Day'
        when 'DU3' then 'Week'
        when 'DU4' then 'Month'
        when 'DU5' then 'Term'
        when 'DU6' then 'Semester'
        when 'DU7' then 'Year'
        else 'No matching value'
        end
      end
    end
  end
end
