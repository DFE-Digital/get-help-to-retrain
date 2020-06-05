class JobVacancyDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def company_and_location
    [formatted_company, location]
      .compact
      .join(' - ')
      .html_safe
  end

  def formatted_closing_date
    formatted_date(closing_date)
  end

  def formatted_date_posted
    formatted_date(date_posted)
  end

  private

  def formatted_company
    return unless company

    content_tag(:strong, company)
  end

  def formatted_date(date_value)
    date_value
      &.to_time
      &.strftime('%d %B %Y')
  end
end
