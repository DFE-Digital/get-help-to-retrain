class TrackingService
  TrackingServiceError = Class.new(StandardError)
  BatchTooBigError = Class.new(StandardError)
  MissingAttributesError = Class.new(StandardError)

  DEBUG_API_ENDPOINT = 'https://www.google-analytics.com/debug/collect'.freeze
  BATCH_API_ENDPOINT = 'https://www.google-analytics.com/batch'.freeze

  MAX_BATCH_SIZE = 20

  attr_reader :ga_tracking_id

  def initialize(ga_tracking_id: Rails.configuration.google_analytics_tracking_id, debug: false)
    @ga_tracking_id = ga_tracking_id
    @debug = debug
  end

  def track_events(key:, props:)
    raise MissingAttributesError, 'Event key and event props must be present' unless key.present? && props.present?

    return unless ga_tracking_id

    send_events(key, props)
  rescue StandardError => e
    Rails.logger.error("Tracking service error: #{e.message}")
    raise TrackingServiceError, e.message
  end

  private

  def debug_uri
    URI.parse(DEBUG_API_ENDPOINT)
  end

  def batch_uri
    URI.parse(BATCH_API_ENDPOINT)
  end

  def send_events(key, props)
    raise BatchTooBigError, "Batch size cannot be over #{MAX_BATCH_SIZE}" if props.size > MAX_BATCH_SIZE

    net_http_post(key, props).body
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

  def build_batch_payload(key, props)
    props.map { |prop| build_payload(key, prop[:label], prop[:value]) }.join("\n")
  end

  def net_http_post(key, props)
    return ::Net::HTTP.post(batch_uri, build_batch_payload(key, props)) unless debugging_enabled?

    prop = props.first

    ::Net::HTTP.post(debug_uri, build_payload(key, prop[:label], prop[:value]))
  end
end
