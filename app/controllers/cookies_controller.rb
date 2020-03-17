class CookiesController < ApplicationController
  def create
    if cookies_params[:cookies] == 'all'
      user_session.cookies = true
    elsif cookies_params[:cookies] == 'partial'
      user_session.cookies = false
    end
    redirect_to(request.env["HTTP_REFERER"])
  end

  private

  def cookies_params
    params.permit(:cookies, :authenticity_token)
  end
end
