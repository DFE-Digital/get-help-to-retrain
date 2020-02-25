module Csv
  class Opportunity < PrimaryActiveRecordBase
    self.table_name = 'csv_opportunities'

    belongs_to :course, inverse_of: :opportunities
    belongs_to :venue, inverse_of: :opportunities, optional: true
    has_one :provider, through: :venue, inverse_of: :opportunities
    has_many :course_lookups, inverse_of: :opportunity
    has_many :opportunity_start_dates, inverse_of: :opportunity

    validates_presence_of :external_opportunities_id

    QUALIFICATION_TYPE = [
      '14-19 Diploma and relevant components',
      'Apprenticeship',
      'Foundation degree',
      'GCE A/AS Level or equivalent',
      'HNC/HND/Higher education awards',
      'International Baccalaureate diploma',
      'Postgraduate qualification',
      'Undergraduate qualification',
      nil
    ].freeze

    QUALIFICATION_LEVEL = ['LV3', 'LV4', 'LV5', 'LV6', 'LV7', 'LV8', 'LV9', nil].freeze

    def self.valid_qualifications
      joins(:course)
        .where.not('csv_courses.qualification_type': QUALIFICATION_TYPE)
        .where.not('csv_courses.qualification_level': QUALIFICATION_LEVEL)
    end
  end
end
