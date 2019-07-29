class CourseGeospatialSearch
  include ActiveModel::Validations

  attr_reader :postcode, :topic, :distance, :courses
  validate :postcode_in_uk, :coordinates

  def initialize(postcode:, topic: nil, distance: 20)
    @postcode = postcode
    @topic = topic
    @distance = distance
  end

  def find_courses
    return Course.none unless valid_uk_postcode? && coordinates.present?

    scope.near(coordinates, distance, units: :mi, order: :distance)
  end

  private

  def coordinates
    return unless valid_uk_postcode?

    @coordinates ||= Geocoder.coordinates(uk_postcode.to_s)
  rescue SocketError, Timeout::Error, Geocoder::Error => e
    Rails.logger.error("Geocoder API error: #{e.message}")
    errors.add(:postcode, I18n.t('courses.api_down_error'))
    return # rubocop:disable Style/RedundantReturn
  end

  def valid_uk_postcode?
    postcode.present? && uk_postcode.full_valid?
  end

  def postcode_in_uk
    errors.add(:postcode, I18n.t('courses.invalid_postcode_error')) unless valid_uk_postcode?
  end

  def uk_postcode
    @uk_postcode ||= UKPostcode.parse(postcode)
  end

  def scope
    topic.present? ? Course.where(topic: topic) : Course.all
  end
end
