# Tokens can only be used once
Passwordless.restrict_token_reuse = true

Passwordless.after_session_save = lambda do |session, request|
  # Default behavior is
  # Passwordless::Mailer.magic_link(session).deliver_now
  # TODO change to Notify service
end
