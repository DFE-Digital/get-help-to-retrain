module Csv
  module Persistor
    class CourseLookup
      attr_reader :opportunity

      def initialize(opportunity)
        @opportunity = opportunity
      end

      def persist!
        return unless subject

        Csv::CourseLookup.create!(
          opportunity: opportunity,
          addressable: addressable,
          subject: subject,
          hours: opportunity.study_modes,
          delivery_type: opportunity.attendance_modes,
          postcode: addressable.postcode
        )
      end

      private

      def addressable
        opportunity.venue || opportunity.course.provider
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
    end
  end
end
