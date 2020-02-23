module Csv
  module Persistor
    class Course
      attr_reader :course_detail

      def initialize(course_detail)
        @course_detail
      end

      def persist!
        Csv::Course.create!(
          course_detail: course_detail
          addressable: addressable
          subject: subject
          hours: course_hours
          delivery_type: delivery_type
          postcode: postcode
        )
      end

      private

      def addressable

      end

      def study_mode(mode)
        if mode == 'SM1'
          'Full time'
        elsif mode == 'SM2'
          'Part time'
        elsif mode == 'SM3'
          'Part of a full-time program'
        elsif mode == 'SM4'
          'Flexible'
        elsif mode == 'SM5'
          'Not known'
        end
      end

      def delivery_mode(mode)
        if mode == 'AM1'
          'Location / campus'
        elsif mode == 'AM2'
          'Face-to-face (non-campus)'
        elsif mode == 'AM3'
          'Work-based'
        elsif mode == 'AM4'
          'Mixed Mode'
        elsif mode == 'AM5'
          'Distance with attendance'
        elsif mode == 'AM6'
          'Distance without attendance'
        elsif mode == 'AM7'
          'Online without attendance'
        elsif mode == 'AM8'
          'Online with attendance'
        elsif mode == 'AM9'
          'Not known'
        end
      end

      def postcode_for(venue, provider)
        venue&.postcode.presence || provider.postcode
      end

    def subject_for(title, qualification_type, level)
      return unless ["Other regulated/accredited qualification", "NVQ  and relevant components", "Course provider certificate (this must include an assessed element)", "Access to higher education", "GCSE or equivalent", "No qualification", "External awarded qualification - Non-accredited", "Functional skill", "Certificate of attendance", "Basic/key skill", "Professional or Industry Specific Qualification"].include?(qualification_type)

      return unless ["LV0", "LV1", "LV2", "LVNA"].include?(level)

      if title =~ /aromatherapy/ || title =~ /resolution/
        return
      elsif title =~ /math/
        subject = 'maths'
      elsif title =~ /english/
        subject = 'english'
      elsif title =~ /esol/
        subject = 'esol'
      else
        subject = nil
      end
    end
  end
end
