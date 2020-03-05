class FindACourseService
  APIError = Class.new(StandardError)

  attr_reader :api_key, :api_base_url

  def initialize(
    api_key: Rails.configuration.find_a_course_api_key,
    api_base_url: Rails.configuration.find_a_course_base_url
  )
    @api_key = api_key
    @api_base_url = api_base_url
  end

  def search
    # Search course endpoint
  end

  def details
    # Search for the course details
  end
end
