class UserSession
  attr_reader :session

  KEYS_TO_RESTORE = %w[
    job_profile_skills
    job_profile_ids
    postcode
    target_job_id
  ].freeze

  def self.merge_sessions(new_session:, previous_session_data:)
    new_session.merge!(previous_session_data.slice(*KEYS_TO_RESTORE))
  end

  def initialize(session)
    @session = session

    @session[:job_profile_skills] ||= {}
    @session[:job_profile_ids] ||= []
  end

  def postcode
    session[:postcode]
  end

  def postcode=(value)
    session[:postcode] = value
  end

  def target_job_id
    session[:target_job_id]
  end

  def target_job_id=(value)
    session[:target_job_id] = value
  end

  def registered?
    session[:registered]
  end

  def registered=(value)
    session[:registered] = value
  end

  def registration_triggered_path
    session[:registration_triggered_path]
  end

  def registration_triggered_path=(url)
    return unless url

    session[:registration_triggered_path] = url
  end

  def job_profile_skills
    session[:job_profile_skills]
  end

  def set_skills_ids_for_profile(job_profile_id, skill_ids)
    job_profile_skills[job_profile_id.to_s] = skill_ids
    session[:job_profile_ids] << job_profile_id unless job_profile_ids.include?(job_profile_id)
  end

  def remove_job_profile(job_profile_id)
    job_profile_skills.delete(job_profile_id.to_s)
    job_profile_ids.delete(job_profile_id)
  end

  def job_profile_skills?
    job_profile_ids.present?
  end

  def job_profiles_cap_reached?
    job_profile_ids.size > 4
  end

  def skill_ids
    job_profile_skills.values.flatten.uniq
  end

  def job_profile_ids
    session[:job_profile_ids]
  end

  def skill_ids_for_profile(id)
    job_profile_skills[id.to_s] || []
  end
end
