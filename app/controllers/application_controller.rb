class ApplicationController < ActionController::Base
  private

  def track_event(event_key, properties = {})
    return unless defined?(TELEMETRY_CLIENT)

    TELEMETRY_CLIENT.track_event(I18n.t(event_key, scope: :events), properties: properties)
  end

  def protect_feature(feature)
    redirect_to task_list_path unless Flipflop.enabled?(feature)
  end
end
