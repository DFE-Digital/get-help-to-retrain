module ApplicationHelper
  def page_title(key)
    content_for(:page_title, I18n.t(key, scope: 'page_titles'))
  end

  def generate_breadcrumbs(current_page = nil, previous_pages)
    links = [
      previous_pages.map { |title, link|
        content_tag(:li, nil, class: 'govuk-breadcrumbs__list-item') {
          link_to(title, link, class: 'govuk-breadcrumbs__link')
        }
      }
    ]

    links << content_tag(:li, current_page, class: 'govuk-breadcrumbs__list-item') if current_page

    safe_join(links)
  end
end
