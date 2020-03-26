class CookiesController < ApplicationController
  def update
    if cookies_params[:cookies][:all]
      user_session.cookies = true
    elsif cookies_params[:cookies][:necessary]
      user_session.cookies = false
    end

    redirect_to(url_parser.get_redirect_path || root_path)
  end

  private

  def cookies_params
    params.permit(:authenticity_token, cookies: %i[all necessary])
  end
end
