class AdminUserSession
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def user_id
    session[:admin_user_id]
  end

  def user_id=(value)
    session[:admin_user_id] = value
  end

  def user_roles
    session[:admin_user_roles]
  end

  def user_roles=(value)
    session[:admin_user_roles] = value
  end
end
