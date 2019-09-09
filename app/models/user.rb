class User < RestrictedActiveRecordBase
  belongs_to :session
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  passwordless_with :email
end
