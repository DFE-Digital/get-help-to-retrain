module Csv
  class OpportunityDecorator < SimpleDelegator
    include ActionView::Helpers::TagHelper

    def provider_full_address
      [
        full_street_address,
        full_region,
        postcode
      ].reject(&:empty?)
        .join('<br>')
        .html_safe
    end

    def course_start_date
      return unless opportunity_start_dates.any?
      return 'Various start dates' if opportunity_start_dates.size > 1

      opportunity_start_dates.first.start_date.strftime('%d %b %Y')
    end

    def course_price
      return unless price.present?
      return 'Free' if price.zero?

      "£#{price}"
    end

    def course_url
      course.booking_url.presence || course.url.presence || provider.url.presence || venue.url.presence
    end

    def course_description
      return if course.description.size <= 15

      course.description
    end

    private

    def full_street_address
      [provider.address_line_1, provider.address_line_2].compact.join(', ')
    end

    def full_region
      [provider.town, provider.county].compact.join(', ')
    end

    def postcode
      provider.postcode
    end
  end
end
