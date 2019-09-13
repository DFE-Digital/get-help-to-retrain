load Passwordless::Engine.root.join('app/controllers/passwordless/sessions_controller.rb')
Passwordless::SessionsController.class_eval do
  after_action :restore_user_session, only: [:show], if: -> { current_user }

  def show
    BCrypt::Password.create(params[:token])

    sign_in passwordless_session

    redirect_to main_app.task_list_path
  rescue Passwordless::Errors::TokenAlreadyClaimedError
    raise ActionController::RoutingError, 'Not Found'
  rescue Passwordless::Errors::SessionTimedOutError
    raise ActionController::RoutingError, 'Not Found'
  end

  def restore_user_session
    current_user.restore_session(session)
  end
end
