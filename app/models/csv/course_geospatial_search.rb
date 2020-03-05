module Csv
  class CourseGeospatialSearch
    include ActiveModel::Validations
    GeocoderAPIError = Class.new(StandardError)

    attr_reader :postcode, :topic, :distance, :hours, :delivery_type
    validates :postcode, presence: { message: I18n.t('courses.no_postcode_error') }
    validate :postcode_in_uk, :postcode_exists

    def initialize(postcode:, topic: nil, options: {})
      @postcode = postcode
      @topic = topic
      @distance = options[:distance] || 20
      @hours = options[:hours] || 'All'
      @delivery_type = options[:delivery_type] || 'All'
    end

    def find_courses
      return Csv::CourseLookup.none unless valid?

      scope.near(coordinates, distance, units: :mi, order: :distance).includes(:opportunity)
    end

    private

    def scope
      topic.present? ? Csv::CourseLookup.where(**selected_options) : Csv::CourseLookup.all
    end

    def selected_options
      {
        subject: topic,
        hours: hours,
        delivery_type: delivery_type
      }.reject { |_, value| value == 'All' }
    end

    def coordinates
      @coordinates ||= Rails.cache.fetch("#{uk_postcode}-coordinates", expires_in: 1.hours) {
        Geocoder.coordinates(uk_postcode.to_s)
      }
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
end