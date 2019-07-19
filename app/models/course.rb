class Course < ApplicationRecord
  InvalidAddressError = Class.new(StandardError)
  GeocoderAPIError = Class.new(StandardError)

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :postcode, presence: true, postcode: true
  validates_presence_of :title, :url, :provider, :topic

  geocoded_by :postcode
  after_validation :format_postcode
  after_validation :geocode, if: -> { postcode_changed? && !latitude_changed? && !latitude_changed? }

  def self.find_courses_near(address:, distance: 5)
    return none unless address.present?

    coordinates = Geocoder.coordinates(parse_postcode(address))
    near(coordinates, distance, units: :mi, order: :distance)
  rescue SocketError, Timeout::Error, Geocoder::Error => e
    Rails.logger.error("Geocoder API error: #{e.message}")
    raise GeocoderAPIError
  end

  def self.parse_postcode(address)
    uk_postcode = UKPostcode.parse(address)
    raise InvalidAddressError unless uk_postcode.full_valid?

    uk_postcode.to_s
  end

  def format_postcode
    return unless postcode

    self.postcode = UKPostcode.parse(postcode).to_s
  end
end
