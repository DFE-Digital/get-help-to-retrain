class UsersController < ApplicationController
  def new
    @user = User.new
    user_session.registration_triggered_from(request.referer, [save_your_results_path]) if request.referer
  end

  def create
    @user = User.find_or_initialize_by(email: user_params[:email])
    if @user.valid?
      setup_user
      render(:show)
    else
      render(:new)
    end
  end

  private

  def user_params
    params.permit(:email, :authenticity_token)
  end

  def setup_user
    if @user.new_record?
      @user.register(user_session, request.base_url)
    else
      passwordless_session = build_passwordless_session(@user)
      @user.sign_in(passwordless_session, request.base_url)
    end
  end
end
