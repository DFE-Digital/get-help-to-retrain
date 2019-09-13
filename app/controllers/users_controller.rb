class UsersController < ApplicationController
  def new
    @user = User.new
    user_session.registration_triggered_from(request.referer, [save_your_results_path]) if request.referer
  end

  def create
    @user = User.find_or_initialize_by(email: user_params[:email])
    if @user.valid?
      register_user
      render(:show)
    else
      render(:new)
    end
  rescue NotifyService::NotifyAPIError
    # TODO: show user an error page, for now render link sent page
    render(:show)
  end

  def sign_in
    @user = User.find_or_initialize_by(email: user_params[:email])
    unless @user.valid?
      redirect_back(fallback_location: root_path, flash: { error: @user.errors[:email] })
    end
  rescue NotifyService::NotifyAPIError
    # TODO: show user an error page, for now render link sent page
    render(:show)
  end

  private

  def user_params
    params.permit(:email, :authenticity_token)
  end

  def register_user
    if @user.new_record?
      @user.register_new_user(user_session, request.base_url)
    else
      sign_in_user
    end
  end

  def sign_in_user
    passwordless_session = build_passwordless_session(@user)
    @user.register_existing_user(passwordless_session, request.base_url, user_session)
  end
end
