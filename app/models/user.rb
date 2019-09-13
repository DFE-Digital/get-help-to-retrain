class User < RestrictedActiveRecordBase
  include Rails.application.routes.url_helpers

  belongs_to :session, optional: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  passwordless_with :email

  def register_new_user(user_session, url)
    return unless user_session && url

    add_session_to_user(user_session.session)
    notify_service.send_email(
      email_address: email,
      template_id: NotifyService::CONFIRMATION_TEMPLATE_ID,
      options: { 'URL' => url }
    )
  end

  def register_existing_user(passwordless_session, url)
    return unless url && passwordless_session&.save

    magic_link = url + token_sign_in_path(token: passwordless_session.token)
    notify_service.send_email(
      email_address: email,
      template_id: NotifyService::LINK_TO_RESULTS_TEMPLATE_ID,
      options: { 'LINK' => magic_link }
    )
  end

  def restore_session(new_session)
    return unless new_session

    UserSession.merge_session(new_session, session.data)
    add_session_to_user(new_session)
  end

  private

  def notify_service
    @notify_service ||= NotifyService.new
  end

  def add_session_to_user(new_session)
    self.session = Session.find_by(session_id: new_session.id)
    save
  end
end
