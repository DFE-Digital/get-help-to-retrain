class Session < RestrictedActiveRecordBase
  has_one :user
end
