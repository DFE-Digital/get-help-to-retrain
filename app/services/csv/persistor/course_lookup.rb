module Csv
  module Persistor
    class CourseLookup
      attr_reader :opportunity

      def initialize(opportunity)
        @opportunity = opportunity
      end

      def persist!
        return unless opportunity_valid

        Csv::CourseLookup.create!(
          opportunity: opportunity,
          addressable: addressable,
          subject: subject,
          hours: hours,
          delivery_type: delivery_type,
          postcode: addressable.postcode
        )
      end

      private

      def opportunity_valid
        subject && hours != 'Part of a full-time program' && attendance_mode != 'Work-based'
      end

      def addressable
        @addressable ||= opportunity.venue || opportunity.course.provider
      end

      def subject
        @subject ||= esol || maths || english
      end

      def esol
        'esol' if course_name =~ /(esol|english for speakers of other languages)/ &&
                  course_name !~ /(resolution|resolving)/
      end

      def maths
        'maths' if course_name =~ /math/ && course_name !~ /aromath/
      end

      def english
        'english' if course_name =~ /english/ &&
                     course_name !~ /(social|esol|english for speakers of other languages)/
      end

      def course_name
        opportunity.course.name.downcase
      end

      def hours
        opportunity.study_modes
      end

      def delivery_type # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        return unless attendance_mode

        case attendance_mode
        when 'Location / campus' then 'Classroom based'
        when 'Face-to-face (non-campus)' then 'Classroom based'
        when 'Mixed Mode' then 'Classroom based'
        when 'Distance with attendance' then 'Distance learning'
        when 'Distance without attendance' then 'Distance learning'
        when 'Online without attendance' then 'Online'
        when 'Online with attendance' then 'Online'
        when 'Not known' then 'Not known'
        end
      end

      def attendance_mode
        opportunity.attendance_modes
      end
    end
  end
end
