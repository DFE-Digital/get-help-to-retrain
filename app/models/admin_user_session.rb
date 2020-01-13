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
end
