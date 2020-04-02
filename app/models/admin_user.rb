class AdminUser < RestrictedActiveRecordBase
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :resource_id, presence: true, uniqueness: true

  def self.from_omniauth(auth_hash)
    user_info = auth_hash[:info] || {}

    admin_user = find_or_initialize_by(
      email: user_info[:email],
      resource_id: auth_hash[:uid]
    )

    admin_user.name = user_info[:name]
    admin_user.roles = roles_from(auth_hash)

    admin_user
  end

  def self.roles_from(auth_hash)
    user_roles = auth_hash.dig(:extra, :user_roles, :value)
    return [] unless user_roles.present?

    groups_to_roles_mapping
      .values_at(*user_roles.pluck(:id))
      .compact
  end

  def self.groups_to_roles_mapping
    {
      Rails.configuration.azure_management_role_id => 'management',
      Rails.configuration.azure_readwrite_role_id => 'readwrite',
      Rails.configuration.azure_read_role_id => 'read'
    }.reject { |k, _v| k.blank? }
  end
end
