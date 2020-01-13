class AdminUser < RestrictedActiveRecordBase
  has_and_belongs_to_many :roles,
                          class_name: 'AdminRole',
                          join_table: 'admin_users_admin_roles',
                          foreign_key: 'admin_role_id',
                          association_foreign_key: 'admin_user_id'

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :resource_id, presence: true, uniqueness: true

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

    AdminRole.where(resource_id: user_roles.pluck(:id))
  end

  def has_role?(role)
    roles.pluck(:name).include?(role)
  end
end
