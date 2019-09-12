load Passwordless::Engine.root.join('app/controllers/passwordless/sessions_controller.rb')
Passwordless::SessionsController.class_eval do
  after_action :restore_user_session, only: [:show], if: -> { current_user }

  def restore_user_session
    current_user.restore_session(user_session)
  end
end
