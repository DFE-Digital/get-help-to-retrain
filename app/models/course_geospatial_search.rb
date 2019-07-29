class CourseGeospatialSearch
  include ActiveModel::Validations

  attr_reader :postcode, :topic, :distance, :courses

  def initialize(postcode:, topic: nil, distance: 20)
    @postcode = postcode
    @topic = topic
    @distance = distance
    @courses = find_courses
  end

  def find_courses
    return Course.none unless valid_uk_postcode? && coordinates.present?

    scope.near(coordinates, distance, units: :mi, order: :distance)
  end

  private

  def coordinates
    @coordinates ||= Geocoder.coordinates(uk_postcode.to_s)
  rescue SocketError, Timeout::Error, Geocoder::Error => e
    Rails.logger.error("Geocoder API error: #{e.message}")
    errors.add(:postcode, I18n.t('courses.api_down_error'))
    return # rubocop:disable Style/RedundantReturn
  end

  def valid_uk_postcode?
    return true if postcode.present? && uk_postcode.full_valid?

    errors.add(:postcode, I18n.t('courses.invalid_postcode_error'))
    return # rubocop:disable Style/RedundantReturn
  end

  def uk_postcode
    @uk_postcode ||= UKPostcode.parse(postcode)
  end

  def scope
    topic.present? ? Course.where(topic: topic) : Course.all
  end
end
