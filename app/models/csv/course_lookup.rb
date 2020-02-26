module Csv
  class CourseLookup < PrimaryActiveRecordBase
    self.table_name = 'csv_course_lookups'

    geocoded_by :postcode

    belongs_to :opportunity, inverse_of: :course_lookups
    has_one :course, through: :opportunity, inverse_of: :course_lookups
    belongs_to :addressable, polymorphic: true

    validates :postcode, presence: true, postcode: true
    validates_presence_of :subject

    after_validation :format_postcode
    after_validation :geocode, if: -> { postcode_changed? && !latitude_changed? && !longitude_changed? }

    scope :geocoded, -> { where.not(latitude: 0).where.not(longitude: 0) }
    scope :not_geocoded, -> { where(latitude: 0, longitude: 0) }

    def format_postcode
      return unless postcode

      self.postcode = UKPostcode.parse(postcode).to_s
    end
  end
end
