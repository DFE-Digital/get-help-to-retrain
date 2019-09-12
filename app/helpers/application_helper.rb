module ApplicationHelper
  def page_title(key)
    content_for(:page_title, I18n.t(key, scope: 'page_titles'))
  end

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

  def user_not_authenticated_or_registered?
    Flipflop.user_authentication? && !(current_user || user_session.registered?)
  end

  def user_not_authenticated?
    Flipflop.user_authentication? && !current_user
  end
end
