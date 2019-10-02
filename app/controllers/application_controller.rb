class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers

  before_action :set_raven_context

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
    event = I18n.t(event_key, scope: :events)
    application_insights_request_id = request.env['ApplicationInsights.request.id']
    properties.present? ? TrackingService.track_event(event, properties, application_insights_request_id) : TrackingService.track_event(event, application_insights_request_id)
  end

  def protect_feature(feature)
    redirect_to task_list_path unless Flipflop.enabled?(feature)
  end

  def set_raven_context
    return unless Rails.configuration.sentry_dsn.present?

    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
