class Course < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :postcode, presence: true, postcode: true
  validates_presence_of :title, :url, :provider, :topic

  geocoded_by :postcode
  after_validation :format_postcode
  after_validation :geocode, if: -> { postcode_changed? && !latitude_changed? && !longitude_changed? }

  def self.find_courses_near(postcode:, topic: nil, distance: 5)
    CourseGeospatialSearch.new(postcode: postcode, topic: topic, distance: distance).find_courses
  end

  def format_postcode
    return unless postcode

    self.postcode = UKPostcode.parse(postcode).to_s
  end
end
