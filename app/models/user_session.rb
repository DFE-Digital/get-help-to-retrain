class UserSession
  attr_reader :session

  def initialize(session)
    @session = session
    @session[:visited_pages] ||= []
  end

  def track_page(page_key)
    session[:visited_pages] << page_key unless session[:visited_pages].include?(page_key)
  end

  def store_at(key:, value:)
    session[key] = value
  end

  def page_visited?(page_key)
    session[:visited_pages].include?(page_key)
  end

  def job_profile_skills?
    job_profile_skills.keys.present?
  end

  def skill_ids
    return skill_ids_for_profile(current_job_id) if Flipflop.skills_builder? && current_job?

    job_profile_skills.values.flatten.uniq
  end

  def job_profile_ids
    return [current_job_id] if Flipflop.skills_builder? && current_job?

    job_profile_skills.keys.flatten.map(&:to_i)
  end

  def skill_ids_for_profile(id)
    job_profile_skills[id.to_s] || []
  end

  def current_job?
    session[:current_job_id].present?
  end

  def current_job_id
    session[:current_job_id]
  end

  def unblock_all_sections?
    page_visited?('skills_matcher_index') &&
      (page_visited?('training_hub') || page_visited?('next_steps'))
  end

  private

  def job_profile_skills
    session.fetch(:job_profile_skills, {})
  end
end
