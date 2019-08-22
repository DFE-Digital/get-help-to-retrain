class CourseGeospatialSearch
  include ActiveModel::Validations
  GeocoderAPIError = Class.new(StandardError)

  attr_reader :postcode, :topic, :distance
  validates :postcode, presence: { message: I18n.t('courses.no_postcode_error') }
  validate :postcode_in_uk, :postcode_exists

  def initialize(postcode:, topic: nil, distance: 20)
    @postcode = postcode
    @topic = topic
    @distance = distance
  end

  def find_courses
    return Course.none unless valid?

    scope.near(coordinates, distance, units: :mi, order: :distance)
  end

  private

  def scope
    topic.present? ? Course.where(topic: topic) : Course.all
  end

  def coordinates
    @coordinates ||= Geocoder.coordinates(uk_postcode.to_s)
  rescue SocketError, Timeout::Error, Geocoder::Error => e
    Rails.logger.error("Geocoder API error: #{e.message}")
    raise GeocoderAPIError
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
end
