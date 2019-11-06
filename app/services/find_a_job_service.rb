class FindAJobService
  attr_reader :api_id, :api_key

  BASE_URL = 'https://findajob.dwp.gov.uk/api/'.freeze
  ResponseError = Class.new(StandardError)
  APIError = Class.new(StandardError)

  def initialize(
    api_id: Rails.configuration.find_a_job_api_id,
    api_key: Rails.configuration.find_a_job_api_key
  )
    @api_id = api_id
    @api_key = api_key
  end

  def job_vacancies(options)
    return {} unless api_id && api_key

    uri = build_uri(path: 'search', options: options)

    JSON.parse(response_body(uri))
  end

  def health_check
    uri = build_uri(path: 'ping')
    JSON.parse(response_body(uri))
  end

  private

  def response_body(uri)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 5) do |http|
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      raise ResponseError, "#{response.code} - #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      response.body
    end
  rescue StandardError => e
    Rails.logger.error("Find a Job Service API error: #{e.inspect}")
    raise APIError, e
  end

  def build_uri(path:, options: {})
    build_uri = URI.join(BASE_URL, path)
    build_uri.query = URI.encode_www_form(query_values(options))
    build_uri
  end

  def query_values(options)
    {
      api_id: api_id,
      api_key: api_key,
      q: options[:name],
      w: outcode(options[:postcode]),
      d: options[:distance],
      p: options[:page]
    }.reject { |_k, v| v.blank? }
  end

  def outcode(postcode)
    return unless postcode

    UKPostcode.parse(postcode).outcode
  end
end
