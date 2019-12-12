class AdminConstraint
  def matches?(_request)
    Rails.configuration.admin_mode
  end
end
