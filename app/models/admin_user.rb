class AdminUser < RestrictedActiveRecordBase
  ROLES = %w[management readwrite read].freeze

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :resource_id, presence: true, uniqueness: true

  scope :with_role, ->(role) { where("roles_mask & #{2**ROLES.index(role)} > 0 ") }

  def self.from_omniauth(auth_hash)
    user_info = auth_hash[:info] || {}

    admin_user = find_or_initialize_by(
      email: user_info[:email],
      name: user_info[:name],
      resource_id: auth_hash[:uid]
    )

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
      Rails.configuration.azure_management_role_id => ROLES[0],
      Rails.configuration.azure_readwrite_role_id => ROLES[1],
      Rails.configuration.azure_read_role_id => ROLES[2]
    }.reject { |k, _v| k.blank? }
  end

  # convert list of roles to bitmask
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  # convert bitmask back to list of roles
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
end
