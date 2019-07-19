class Course < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :postcode, presence: true, postcode: true
  validates_presence_of :title, :url, :provider, :topic

  geocoded_by :postcode
  after_validation :format_postcode
  after_validation :geocode, if: -> { postcode_changed? && !latitude_changed? && !latitude_changed? }

  def format_postcode
    return unless postcode

    self.postcode = UKPostcode.parse(postcode).to_s
  end
end
