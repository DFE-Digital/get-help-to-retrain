class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  before_action :set_request_path

  def user_session
    @user_session ||= UserSession.new(session)
  end

  # The authenticate method comes from the passwordless gem.
  #  This is authenticating the passwordless session.
  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  helper_method :user_session, :current_user

  private

  def track_event(event_key, properties = {})
    return unless defined?(TELEMETRY_CLIENT)

    TELEMETRY_CLIENT.track_event(I18n.t(event_key, scope: :events), properties: properties)
  end

  def protect_feature(feature)
    redirect_to task_list_path unless Flipflop.enabled?(feature)
  end

  def set_request_path
    user_session.request_path = request.path
  end
end
