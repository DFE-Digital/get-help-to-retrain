module ApplicationHelper
  def generate_breadcrumbs(current_page, previous_pages)
    safe_join(
      [
        previous_pages.map { |title, link|
          content_tag(:li, nil, class: 'govuk-breadcrumbs__list-item') {
            link_to(title, link, class: 'govuk-breadcrumbs__link')
          }
        },
        content_tag(:li, current_page, class: 'govuk-breadcrumbs__list-item')
      ]
    )
  end
end
