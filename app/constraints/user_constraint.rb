class UserConstraint
  def matches?(_request)
    Rails.configuration.admin_mode == false
  end
end
