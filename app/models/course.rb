class Course < ApplicationRecord
  InvalidPostcodeError = Class.new(StandardError)
  GeocoderAPIError = Class.new(StandardError)

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :postcode, presence: true, postcode: true
  validates_presence_of :title, :url, :provider, :topic

  geocoded_by :postcode
  after_validation :format_postcode
  after_validation :geocode, if: -> { postcode_changed? && !latitude_changed? && !longitude_changed? }

  def self.find_courses_near(search_postcode:, topic: nil, distance: 5)
    return none unless search_postcode.present?

    coordinates = Geocoder.coordinates(parse_postcode(search_postcode))

    courses = near(coordinates, distance, units: :mi, order: :distance)
    courses = courses.where(topic: topic) if topic.present?
    courses
  rescue SocketError, Timeout::Error, Geocoder::Error => e
    Rails.logger.error("Geocoder API error: #{e.message}")
    raise GeocoderAPIError
  end

  def self.parse_postcode(str)
    uk_postcode = UKPostcode.parse(str)
    raise InvalidPostcodeError unless uk_postcode.full_valid?

    uk_postcode.to_s
  end

  def format_postcode
    return unless postcode

    self.postcode = UKPostcode.parse(postcode).to_s
  end
end
