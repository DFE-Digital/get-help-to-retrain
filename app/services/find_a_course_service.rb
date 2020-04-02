class FindACourseService
  APIError = Class.new(StandardError)
  ResponseError = Class.new(StandardError)
  PostcodeNotFoundError = Class.new(StandardError)

  attr_reader :api_key, :api_base_url

  def initialize(
    api_key: Rails.configuration.find_a_course_api_key,
    api_base_url: Rails.configuration.find_a_course_api_base_url
  )
    @api_key = api_key
    @api_base_url = api_base_url
  end

  def search(options: {})
    return {} unless api_key && api_base_url

    uri = build_uri(path: 'coursesearch')
    headers = headers(content_type: 'application/json-patch+json')

    request = Net::HTTP::Post.new(uri, headers)
    request.body = build_search(options).to_json

    JSON.parse(response_body(uri, request))
  end

  def details(course_id:, course_run_id:)
    return {} unless [api_key, api_base_url, course_id, course_run_id].all?(&:present?)

    find_course_details_for(course_id: course_id, course_run_id: course_run_id)
  end

  private

  def build_uri(path:)
    URI.join(api_base_url, path)
  end

  def headers(content_type:)
    {
      'Content-Type' => content_type,
      'Ocp-Apim-Subscription-Key' => api_key
    }
  end

  def response_body(uri, request)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', read_timeout: 5) do |http|
      response = http.request(request)

      return response.body if response.is_a?(Net::HTTPSuccess)

      raise ResponseError, "#{response.code}: #{response.message} - #{response.body}"
    end
  rescue StandardError => e
    Rails.logger.error("Find a Course Service API error: #{e.inspect}")

    raise PostcodeNotFoundError, e if e.message =~ /PostcodeNotFound/

    raise APIError, e
  end

  def find_course_details_for(course_id:, course_run_id:)
    uri = build_uri(path: 'courserundetail')

    uri.query = URI.encode_www_form('CourseId' => course_id, 'CourseRunId' => course_run_id)

    request = Net::HTTP::Get.new(
      uri.request_uri,
      headers(
        content_type: 'application/x-www-form-urlencoded'
      )
    )

    JSON.parse(response_body(uri, request))
  end

  def build_search(options) # rubocop:disable Metrics/MethodLength
    {
      'subjectKeyword' => options[:keyword],
      'distance' => options[:distance],
      'qualificationLevels' => options[:qualification_levels],
      'studyModes' => options[:study_modes],
      'deliveryModes' => options[:delivery_modes],
      'postcode' => options[:postcode],
      'sortBy' => options[:sort_by],
      'limit' => options[:limit],
      'start' => options[:start]
    }.select { |_k, v| v.present? }
  end
end
