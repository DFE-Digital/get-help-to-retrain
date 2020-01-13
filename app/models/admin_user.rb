class AdminUser < RestrictedActiveRecordBase
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :resource_id, presence: true, uniqueness: true

  has_paper_trail only: %i[update destroy]

  def self.from_omniauth(auth_hash)
    user_info = auth_hash[:info] || {}

    find_or_initialize_by(
      email: user_info[:email],
      name: user_info[:name],
      resource_id: auth_hash[:uid]
    )
  end

  def roles_from(auth_hash)
    roles_data = auth_hash.dig(:extra, :user_roles, :value)

    return [] unless roles_data.present?

    # We are extracting ids instead of names as ids will not change, while names could change
    roles_data.pluck(:id)
  end
end
