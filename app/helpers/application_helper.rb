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
        content_tag(:li, current_page, class: 'govuk-breadcrumbs__list-item', aria: { current: 'page' })
      ]
    )
  end

  def user_not_authenticated_and_not_registered?
    user_not_authenticated? && !user_session.registered?
  end

  def user_not_authenticated?
    !current_user
  end

  def target_job
    @target_job ||= JobProfile.find_by(id: user_session.target_job_id)
  end

  def back_link(custom_url: nil, paths_to_ignore: [])
    link_to('Back', custom_url || back_url(paths_to_ignore), class: 'govuk-back-link')
  end

  def show_cookie_banner?
    return if current_page?(cookies_policy_path)

    cookies['_get_help_to_retrain_session'].blank? || user_session.cookies.nil?
  end

  private

  def back_url(paths_to_ignore)
    url = url_parser.get_redirect_path(paths_to_ignore: paths_to_ignore)

    return root_path if url.nil? || request.original_url.include?(url)

    url
  end
end
