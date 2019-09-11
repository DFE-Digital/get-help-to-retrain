class User < RestrictedActiveRecordBase
  belongs_to :session, optional: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  passwordless_with :email
end
