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
    return unless start_date

    start_date.first.start_date.strftime('%d %b %Y')
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
    url = "http://#{url}" unless url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]

    url
  end
end
