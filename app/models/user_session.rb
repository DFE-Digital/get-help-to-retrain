class UserSession
  attr_reader :session

  def initialize(session)
    @session = session
    @session[:visited_pages] ||= []
  end

  def track_page(page_key)
    session[:visited_pages] << page_key unless session[:visited_pages].include?(page_key)
  end

  def page_visited?(page_key)
    session[:visited_pages].include?(page_key)
  end

  def job_profile_skills?
    session.fetch(:job_profile_skills, {}).keys.present?
  end
end
