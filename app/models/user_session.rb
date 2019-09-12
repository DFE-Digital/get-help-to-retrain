class UserSession
  attr_reader :session

  KEYS_TO_RESTORE = %w[
    visited_pages
    job_profile_skills
    job_profile_ids
    postcode
    current_job_id
    version
  ].freeze

  def initialize(session)
    @session = session
    @session.destroy unless version == expected_version

    @session[:visited_pages] ||= []
    @session[:job_profile_skills] ||= {}
    @session[:job_profile_ids] ||= []
    @session[:version] ||= expected_version
  end

  def version
    session[:version]
  end

  def postcode
    session[:postcode]
  end

  def postcode=(value)
    session[:postcode] = value
  end

  def registered
    session[:registered]
  end

  def registered=(value)
    session[:registered] = value
  end

  def registration_triggered_path
    session[:registration_triggered_path]
  end

  def registration_triggered_from(referer, paths_to_ignore = [])
    path = URI(referer).request_uri
    return if paths_to_ignore.include?(path)

    session[:registration_triggered_path] = path if Rails.application.routes.recognize_path(path)
  rescue ActionController::RoutingError => e
    Rails.logger.error("Route not from app when registering: #{e.message}")
  end

  def current_job_id
    session[:current_job_id]
  end

  def current_job_id=(value)
    session[:current_job_id] = value
  end

  def job_profile_skills
    session[:job_profile_skills]
  end

  def merge_session(previous_session_data)
    session.merge!(previous_session_data.slice(*KEYS_TO_RESTORE))
  end

  def set_skills_ids_for_profile(job_profile_id, skill_ids)
    job_profile_skills[job_profile_id.to_s] = skill_ids
    session[:job_profile_ids] << job_profile_id unless job_profile_ids.include?(job_profile_id)
  end

  def track_page(page_key)
    session[:visited_pages] << page_key unless page_visited?(page_key)
  end

  def current_job?
    session[:current_job_id].present?
  end

  def page_visited?(page_key)
    session[:visited_pages].include?(page_key)
  end

  def job_profile_skills?
    job_profile_ids.present?
  end

  def job_profiles_cap_reached?
    job_profile_skills
      .reject { |_k, v| v.size.zero? }
      .keys
      .size > 4
  end

  def unblock_all_sections?
    page_visited?('skills_matcher_index') &&
      (page_visited?('training_hub') || page_visited?('next_steps'))
  end

  def skill_ids
    return skill_ids_for_profile(current_job_id) if current_job?

    job_profile_skills.values.flatten.uniq
  end

  def job_profile_ids
    return [current_job_id] if current_job?

    session[:job_profile_ids]
  end

  def skill_ids_for_profile(id)
    job_profile_skills[id.to_s] || []
  end

  private

  def expected_version
    Flipflop.skills_builder_v2? ? 2 : 1
  end
end
