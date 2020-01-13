class AdminRole < RestrictedActiveRecordBase
  has_and_belongs_to_many :admin_users

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
  validates :resource_id, presence: true, uniqueness: true
end
