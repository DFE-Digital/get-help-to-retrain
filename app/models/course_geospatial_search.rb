class CourseGeospatialSearch
  InvalidPostcodeError = Class.new(StandardError)
  GeocoderAPIError = Class.new(StandardError)

  attr_reader :postcode, :topic, :distance

  def initialize(postcode:, topic:, distance:)
    @postcode = postcode
    @topic = topic
    @distance = distance
  end

  def find_courses
    return Course.all unless postcode.present?

    courses.near(coordinates, distance, units: :mi, order: :distance)
  end

  private

  def uk_postcode
    uk_postcode = UKPostcode.parse(postcode)
    raise InvalidPostcodeError unless uk_postcode.full_valid?

    uk_postcode.to_s
  end

  def coordinates
    Geocoder.coordinates(uk_postcode)
  rescue SocketError, Timeout::Error, Geocoder::Error => e
    Rails.logger.error("Geocoder API error: #{e.message}")
    raise GeocoderAPIError
  end

  def courses
    topic.present? ? Course.where(topic: topic) : Course.all
  end
end
