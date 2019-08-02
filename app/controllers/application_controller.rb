class ApplicationController < ActionController::Base
  private

  def track_event(event_key, properties = {})
    TELEMETRY_CLIENT.track_event I18n.t(event_key), properties: properties if defined?(TELEMETRY_CLIENT)
  end

  def protect_feature(feature)
    redirect_to task_list_path unless Flipflop.enabled?(feature)
  end
end
