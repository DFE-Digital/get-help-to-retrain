class JobVacancyDecorator < SimpleDelegator
  include ActionView::Helpers::TagHelper

  def company_and_location
    [formatted_company, location]
      .compact
      .join(' - ')
      .html_safe
  end

  private

  def formatted_company
    return unless company

    content_tag(:b, company)
  end
end
