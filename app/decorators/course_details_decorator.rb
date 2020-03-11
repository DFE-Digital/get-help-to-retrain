class CourseDetailsDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def provider_full_address
    [
      full_street_address,
      full_region,
      provider_postcode
    ].reject(&:empty?)
      .join('<br>')
      .html_safe
  end

  def formatted_start_date
    return DateTime.parse(start_date).strftime('%d %b %Y') if start_date

    flexible_start_date ? 'Flexible start date' : 'Contact provider'
  rescue StandardError => e
    Rails.logger.error("Course details - start date error: #{e.inspect}")
    nil
  end

  def price
    return unless cost.present?
    return 'Free' if cost.zero?

    "£#{cost}"
  end

  def course_url
    url = website || provider_website || venue_website

    return unless url.present?

    add_protocol(url)
  end

  def course_description
    return if description.size <= 15

    description
  end

  private

  def full_street_address
    [provider_address_line_1, provider_address_line_2].compact.join(', ')
  end

  def full_region
    [provider_town, provider_county].compact.join(', ')
  end

  def add_protocol(url)
    url = "http://#{url}" unless url.match(%r{https?://}) || url.match(%r{http?://})

    url
  end
end
