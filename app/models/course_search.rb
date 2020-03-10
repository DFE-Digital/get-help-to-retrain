class CourseSearch
  include ActiveModel::Validations
  GeocoderAPIError = Class.new(StandardError)

  attr_reader :postcode, :topic, :distance, :page, :hours, :delivery_type, :find_a_course
  validates :postcode, presence: { message: I18n.t('courses.no_postcode_error') }
  validate :postcode_in_uk, :postcode_exists
  validates_presence_of :topic

  def initialize(postcode:, topic:, find_a_course: FindACourseService.new, options: {})
    @postcode = postcode
    @topic = topic
    @page = options[:page] || '1'
    @distance = options[:distance] || '20'
    @hours = options[:hours] || '0'
    @delivery_type = options[:delivery_type] || '0'
    @find_a_course = find_a_course
  end

  def search
    return [] unless valid?

    find_a_course_response
      .fetch('results', [])
      .map { |course| SearchCourse.new(course) }
  end

  def count
    return unless valid?

    find_a_course_response['total'] || 0
  end

  private

  def selected_options # rubocop:disable Metrics/MethodLength
    {
      keyword: topic,
      distance: distance,
      qualification_levels: %w[1 2 X E],
      study_modes: [hours],
      delivery_modes: [delivery_type],
      postcode: uk_postcode.to_s,
      sort_by: 4,
      limit: 10,
      start: start_index
    }.reject { |_, value| value == ['0'] }
  end

  def start_index
    return 0 if page.to_i == 1

    10 * (page.to_i - 1)
  end

  def postcode_in_uk
    return unless errors.blank?

    errors.add(:postcode, I18n.t('courses.invalid_postcode_error')) unless valid_uk_postcode?
  end

  def postcode_exists
    return unless errors.blank?

    errors.add(:postcode, I18n.t('courses.nonexisting_postcode_error')) unless coordinates.present?
  end

  def valid_uk_postcode?
    uk_postcode.full_valid?
  end

  def uk_postcode
    @uk_postcode ||= UKPostcode.parse(postcode)
  end

  def coordinates
    @coordinates ||= Rails.cache.fetch("#{uk_postcode}-coordinates", expires_in: 1.hours) {
      Geocoder.coordinates(uk_postcode.to_s)
    }
  rescue SocketError, Timeout::Error, Geocoder::Error => e
    Rails.logger.error("Geocoder API error: #{e.message}")
    raise GeocoderAPIError
  end

  def find_a_course_response
    @find_a_course_response ||= find_a_course.search(
      options: selected_options
    )
  end
end
