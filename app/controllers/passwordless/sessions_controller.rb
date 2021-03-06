load Passwordless::Engine.root.join('app/controllers/passwordless/sessions_controller.rb')
Passwordless::SessionsController.class_eval do
  after_action :restore_user_session, only: [:show], if: -> { current_user }

  def show
    # Make it "slow" on purpose to make brute-force attacks more of a hassle
    BCrypt::Password.create(params[:token])

    sign_in passwordless_session
    track_event(:progress, 'return_journey', 'events.return_to_saved_link')

    redirect_to main_app.task_list_path
  rescue Passwordless::Errors::TokenAlreadyClaimedError,
         Passwordless::Errors::SessionTimedOutError,
         ActiveRecord::RecordNotFound
    redirect_to main_app.link_expired_path
  end

  def restore_user_session
    current_user.restore_session(session)
  end
end
