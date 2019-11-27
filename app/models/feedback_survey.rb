class FeedbackSurvey < RestrictedActiveRecordBase
  enum page_useful: { yes: true, no: false }
  validates :page_useful, presence: true
end
