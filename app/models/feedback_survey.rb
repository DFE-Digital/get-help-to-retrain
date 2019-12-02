class FeedbackSurvey < RestrictedActiveRecordBase
  enum page_useful: { yes: true, no: false }
  validates :page_useful, :url, presence: true
  validates :message, length: { maximum: 250 }
end
