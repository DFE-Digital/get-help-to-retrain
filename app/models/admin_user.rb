class AdminUser < RestrictedActiveRecordBase
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :name, presence: true

  def self.from_omniauth(auth_hash)
    user_info = auth_hash.dig(:extra, :user_info)

    return unless user_info.present?

    find_or_create_by(
      email: user_info[:mail],
      name: user_info[:displayName],
      resource_id: user_info[:id]
    )
  end

  def roles_from(auth_hash)
    roles_data = auth_hash.dig(:extra, :user_roles, :value)

    return [] unless roles_data.present?

    # We are extracting ids instead of names as ids will not change, while names could change
    roles_data.pluck(:id)
  end
end
