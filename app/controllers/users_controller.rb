class UsersController < ApplicationController
  def new
    @user = User.new
    set_redirect_path_for_registration
  end

  def create
    @user = User.find_or_initialize_by(email: user_params[:email])
    if @user.valid?
      register_user
      render(:registration_link_sent)
    else
      render(:new)
    end
  rescue NotifyService::NotifyAPIError
    # TODO: show user an error page, for now render link sent page
    render(:registration_link_sent)
  end

  def sign_in
    @user = User.find_or_initialize_by(email: user_params[:email])
    if @user.valid?
      sign_in_user unless @user.new_record?
      redirect_to(link_sent_path(email: @user.email))
    else
      redirect_to(build_redirect_url || root_path, flash: { error: @user.errors[:email] })
    end
  rescue NotifyService::NotifyAPIError
    # TODO: show user an error page, for now render link sent page
    redirect_to(link_sent_path(email: @user.email))
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
    user_session.registered = true
  end

  def sign_in_user
    passwordless_session = build_passwordless_session(@user)
    @user.register_existing_user(passwordless_session, request.base_url)
  end

  def set_redirect_path_for_registration
    redirect_url = url_parser.get_redirect_path(paths_to_ignore: [save_your_results_path])
    user_session.registration_triggered_path = redirect_url
  end

  def build_redirect_url
    url_parser.build_redirect_url_with(
      param_name: 'email',
      param_value: @user.email,
      anchor: 'sign-in'
    )
  end

  def url_parser
    @url_parser ||= UrlParser.new(request.referer, request.host)
  end
end
