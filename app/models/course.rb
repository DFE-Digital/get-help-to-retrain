class Course < PrimaryActiveRecordBase
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :postcode, presence: true, postcode: true
  validates_presence_of :title, :url, :provider, :topic

  geocoded_by :postcode
  after_validation :format_postcode
  after_validation :geocode, if: -> { postcode_changed? && !latitude_changed? && !longitude_changed? }

  scope :geocoded, -> { where.not(latitude: 0).where.not(longitude: 0) }
  scope :not_geocoded, -> { where(latitude: 0, longitude: 0) }

  has_paper_trail on: %i[update]

  def format_postcode
    return unless postcode

    self.postcode = UKPostcode.parse(postcode).to_s
  end
end
