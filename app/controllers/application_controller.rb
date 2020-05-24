class ApplicationController < ActionController::Base
  include Passwordless::ControllerHelpers
  include GaTrackingHelper
  include Admin::AuthenticationHelper

  before_action :set_raven_context
  before_action :set_paper_trail_whodunnit, if: proc { Rails.configuration.admin_mode }

  before_action :redirect_unless_postcode, unless: proc {
    Rails.configuration.admin_mode ||
      %w[check_your_skills courses job_profiles_skills skills].exclude?(controller_name)
  }

  def user_session
    @user_session ||= UserSession.new(session)
  end

  # The authenticate method comes from the passwordless gem (note this refers to Passwordless::Session)
  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def target_job
    helpers.target_job
  end

  def redirect_unless_target_job
    redirect_to task_list_path unless target_job.present?
  end

  def redirect_unless_postcode
    return redirect_to root_path unless user_session.postcode.present?
  end

  def url_parser
    @url_parser ||= UrlParser.new(request.referer, request.host, request.original_url)
  end

  helper_method :user_session, :current_user, :url_parser

  private

  def track_event(event_key, event_value, scope = 'events')
    event_label = I18n.t(event_key, scope: scope)

    track_events(
      [
        {
          key: event_key,
          label: event_label,
          value: event_value
        }
      ]
    )
  end

  def track_events(props = [])
    TrackingService.new(client_tracking_data: client_tracking_data).track_events(props: props)
  rescue TrackingService::TrackingServiceError
    nil
  end

  def set_raven_context
    return unless Rails.configuration.sentry_dsn.present?

    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
