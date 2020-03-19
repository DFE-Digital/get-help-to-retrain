class CourseDetailsDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::NumberHelper

  def provider_full_address
    [
      full_street_address,
      full_region,
      provider_postcode
    ].reject(&:blank?)
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

    "£#{number_with_precision(cost, precision: 2)}"
  end

  def course_url
    url = website || provider_website || venue_website

    return unless url.present?

    add_protocol(url)
  end

  def course_description
    return if description.nil? || description.size <= 15

    description
  end

  def course_qualification_level
    return unless qualification_level.present?

    case qualification_level.downcase
    when 'x' then 'Unknown'
    when 'e' then 'Entry Level'
    when ('1'..'8') then "Level #{qualification_level}"
    end
  end

  def course_delivery_mode
    return unless delivery_mode.present?

    case delivery_mode.downcase
    when 'classroombased' then 'Classroom based'
    when 'workbased' then 'Work based'
    when 'online' then 'Online'
    end
  end

  def course_study_mode
    return unless study_mode.present?

    case study_mode.downcase
    when 'parttime' then 'Part-time'
    when 'fulltime' then 'Full-time'
    when 'flexible' then 'Flexible'
    end
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
