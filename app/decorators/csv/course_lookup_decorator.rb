module Csv
  class CourseLookupDecorator < SimpleDelegator
    include ActionView::Helpers::TagHelper

    def full_address
      [
        full_street_address,
        full_region,
        postcode
      ].reject(&:empty?)
        .join('<br>')
        .html_safe
    end

    private

    def full_street_address
      [addressable.address_line_1, addressable.address_line_2].compact.join(', ')
    end

    def full_region
      [addressable.town, addressable.county].compact.join(', ')
    end

    def postcode
      addressable.postcode
    end
  end
end

