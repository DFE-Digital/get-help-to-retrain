class GaTrackingService
  GaTrackingServiceError = Class.new(StandardError)

  API_ENDPOINT = 'https://www.google-analytics.com/collect'.freeze

  attr_reader :response

  def initialize(ga_tracking_id: Rails.configuration.ga_tracking_id)
    @ga_tracking_id = ga_tracking_id
  end

  def track(payload: nil)
    return unless payload

    request.set_form_data(payload.merge(tid: @ga_tracking_id))

    @response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') { |http|
      http.request(request)
    }

    return @response.body if response_successful?

    handle_api_errors
  rescue StandardError => e
    Rails.logger.error("GA Tracking service error: #{e.message}")
    raise GaTrackingServiceError, e.message
  end

  private

  def ga_tracking_id
    raise 'GA Tracking ID is not set' unless @ga_tracking_id.present?

    @ga_tracking_id
  end

  def response_successful?
    response.is_a? Net::HTTPSuccess
  end

  def uri
    @uri ||= URI.parse(API_ENDPOINT)
  end

  def request
    @request ||= Net::HTTP::Post.new(uri)
  end

  def handle_api_errors
    Rails.logger.error("GA Tracking Service error: #{response.body}, code: #{response.code}")

    raise GaTrackingServiceError, "Code: #{response.code}, response: #{response.body}"
  end
end
