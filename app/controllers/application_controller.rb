class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  before_action :set_raven_context

  def user_session
    @user_session ||= UserSession.new(session)
  end

  def save_in_session(auth_hash)
    # Save the token info
    session[:graph_token_hash] = auth_hash.dig(:credentials)
    # Save the user's display name
    session[:user_name] = auth_hash.dig(:extra, :raw_info, :displayName)
    # Save the user's email address
    # Use the mail field first. If that's empty, fall back on
    # userPrincipalName
    session[:user_email] = auth_hash.dig(:extra, :raw_info, :mail) ||
                           auth_hash.dig(:extra, :raw_info, :userPrincipalName)
  end

  # The authenticate method comes from the passwordless gem (note this refers to Passwordless::Session)
  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def target_job
    helpers.target_job
  end

  helper_method :user_session, :current_user

  private

  def track_event(event_key, properties = {})
    event = I18n.t(event_key, scope: :events)
    properties.present? ? TrackingService.track_event(event, properties) : TrackingService.track_event(event)
  end

  def set_raven_context
    return unless Rails.configuration.sentry_dsn.present?

    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
