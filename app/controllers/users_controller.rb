class UsersController < ApplicationController
  def new
    @user = User.new
    set_redirect_path_for_registration
  end

  def create
    register_with(partial: :registration_results_saved)
  end

  def registration_send_email_again
    register_with(partial: :registration_email_sent_again)
  end

  def return_to_saved_results
    @user = User.new
  end

  def sign_in
    sign_in_with(partial: :sign_in_link_sent)
  end

  def sign_in_send_email_again
    sign_in_with(partial: :sign_in_link_sent_again)
  end

  private

  def user_params
    params.permit(:email, :authenticity_token)
  end

  def register_user
    if user.new_record?
      user.register_new_user(user_session, request.base_url)

      track_event(:progress, 'save_journey', 'events.save')
    else
      sign_in_user
    end
    user_session.registered = true
  end

  def sign_in_user
    passwordless_session = build_passwordless_session(user)
    user.register_existing_user(passwordless_session, request.base_url)

    track_event(:progress, 'return_journey', 'events.return_to_saved')
  end

  def set_redirect_path_for_registration
    redirect_url = url_parser.get_redirect_path(paths_to_ignore: [save_your_results_path])
    user_session.registration_triggered_path = redirect_url
  end

  def sign_in_with(partial:)
    if user.valid?
      sign_in_user unless user.new_record?
      render(partial)
    else
      render(:return_to_saved_results)
    end
  rescue NotifyService::NotifyAPIError
    redirect_to return_to_saved_results_error_path
  end

  def register_with(partial:)
    if user.valid?
      register_user
      render(partial)
    else
      render(:new)
    end
  rescue NotifyService::NotifyAPIError
    redirect_to save_results_error_path
  end

  def user
    @user ||= User.find_or_initialize_by(email: user_params[:email])
  end
end
