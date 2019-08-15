class SkillsMatcher
  attr_reader :user_session, :job_profile_id

  def initialize(user_session:)
    @user_session = user_session
  end

  def match
    return JobProfile.none unless user_session[:job_profile_skills].present?

    build_query
  end

  def job_profile_scores
    user_skills_ids_count = user_skill_ids.count
    @job_profile_scores ||= build_query.each_with_object({}) do |job_profile, hash|
      hash[job_profile.id] = job_profile.skills_matched.to_f / user_skills_ids_count * 100
    end
  end

  private

  def job_profile_skills_subquery
    JobProfileSkill
      .select(:job_profile_id, 'COUNT(job_profile_id) AS skills_matched')
      .where(skill_id: user_skill_ids)
      .group(:job_profile_id)
      .to_sql
  end

  def job_profiles_subquery
    JobProfile
      .select(:skills_matched, 'array_agg(id order by name ASC) as alphabetically_ordered_ids')
      .from(Arel.sql("(#{job_profile_skills_subquery}) as ranked_job_profiles"))
      .joins('LEFT JOIN job_profiles ON job_profiles.id = ranked_job_profiles.job_profile_id')
      .where.not(id: user_job_profile_ids)
      .group(:skills_matched)
      .order(skills_matched: :desc)
      .to_sql
  end

  def build_query
    @build_query ||= begin
      JobProfile
        .select(
          :skills_matched, :id, :name, :description, :alternative_titles, :salary_min, :salary_max, :slug, :growth
        )
        .from(Arel.sql(job_profile_ids_unnest_query))
        .joins('LEFT JOIN job_profiles ON job_profiles.id = ordered_id')
    end
  end

  def job_profile_ids_unnest_query
    "(#{job_profiles_subquery}) as ordered_query, unnest(alphabetically_ordered_ids) WITH ORDINALITY ordered_id"
  end

  def user_skill_ids
    return user_session[:job_profile_skills][current_job_id.to_s] if current_job_id.present?

    user_session[:job_profile_skills].values.flatten.uniq
  end

  def user_job_profile_ids
    return [current_job_id] if current_job_id.present?

    user_session[:job_profile_skills].keys.flatten.map(&:to_i)
  end

  def current_job_id
    user_session[:current_job_id]
  end
end
