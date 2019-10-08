class FindAJobService
  attr_reader :api_id, :api_key, :query, :postcode, :distance

  BASE_URL = 'https://findajob.dwp.gov.uk/api/search'.freeze
  ResponseError = Class.new(StandardError)

  def initialize(
    api_id: Rails.configuration.find_a_job_api_id,
    api_key: Rails.configuration.find_a_job_api_key,
    options:
  )
    @api_id = api_id
    @api_key = api_key
    @query = options[:query]
    @postcode = options[:postcode]
    @distance = options[:distance]
  end

  def job_vacancies
    JSON
      .parse(response_body)
      .dig('pager', 'total_entries')
  end

  private

  def response_body
    return '{}' unless api_id && api_key

    perform_request
  rescue StandardError => e
    Rails.logger.error("Find a Job Service API error: #{e.inspect}")

    '{}'
  end

  def perform_request
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 120) do |http|
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      raise ResponseError, "#{uri.host} : #{response.inspect}" unless response.is_a?(Net::HTTPSuccess)

      response.body
    end
  end

  def uri
    uri = URI(BASE_URL)
    uri.query = URI.encode_www_form(query_values)
    uri
  end

  def query_values
    {
      api_id: api_id,
      api_key: api_key,
      q: query,
      w: outcode,
      d: distance
    }.reject { |_k, v| v.nil? }
  end

  def outcode
    return unless postcode

    UKPostcode.parse(postcode).outcode
  end
end
