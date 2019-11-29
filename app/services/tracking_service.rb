class TrackingService
  TrackingServiceError = Class.new(StandardError)

  API_ENDPOINT = 'https://www.google-analytics.com/collect'.freeze
  DEBUG_API_ENDPOINT = 'https://www.google-analytics.com/debug/collect'.freeze

  attr_reader :ga_tracking_id

  def initialize(ga_tracking_id: Rails.configuration.google_analytics_tracking_id, debug: false)
    @ga_tracking_id = ga_tracking_id
    @debug = debug
  end

  def track_event(key:, label:, value:)
    return unless ga_tracking_id && [key, label, value].all?

    send_event(key, label, value)
  rescue StandardError => e
    Rails.logger.error("Tracking service error: #{e.message}")
    raise TrackingServiceError, e.message
  end

  private

  def uri
    @uri ||= begin
      return URI.parse(DEBUG_API_ENDPOINT) if debugging_enabled?

      URI.parse(API_ENDPOINT)
    end
  end

  def send_event(key, label, value)
    ::Net::HTTP.post(uri, build_payload(key, label, value)).body
  end

  def debugging_enabled?
    @debug
  end

  def anonymized_client_id
    SecureRandom.uuid
  end

  def build_payload(key, label, value)
    URI.encode_www_form(
      tid: ga_tracking_id,
      cid: anonymized_client_id,
      t: 'event',
      v: 1,
      ec: key,
      el: label,
      ea: value
    )
  end
end
