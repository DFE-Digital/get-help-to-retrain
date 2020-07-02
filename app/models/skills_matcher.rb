class SkillsMatcher
  attr_reader :user_session, :options

  def initialize(user_session, options = {})
    @user_session = user_session
    @options = options
  end

  def match
    return JobProfile.none unless user_session.job_profile_skills?

    build_query
  end

  def job_profile_scores
    user_skills_ids_count = user_session.skill_ids.size
    @job_profile_scores ||= build_query.each_with_object({}) do |job_profile, hash|
      hash[job_profile.id] = job_profile.skills_matched.to_f / user_skills_ids_count * 100
    end
  end

  private

  def skills_matched_query
    JobProfileSkill
      .select(:job_profile_id, 'MIN(rarity) as skills_rarity', 'COUNT(job_profile_id) AS skills_matched')
      .joins('INNER JOIN skills ON skills.id = job_profile_skills.skill_id')
      .joins('INNER JOIN skill_criss_crosses on job_profile_skills.skill_id = skill_criss_crosses.skill_a_id')
      .where(skill_criss_crosses: { skill_b_id: user_session.skill_ids })
      .group(:job_profile_id)
      .to_sql
  end

  # rubocop:disable Metrics/MethodLength
  def build_query
    @build_query ||= begin
      job_profile_scope
        .select(
          :skills_matched, :id, :name, :description, :alternative_titles, :salary_min, :salary_max, :slug, :growth,
          growth_type
        )
        .from(Arel.sql("(#{skills_matched_query}) as ranked_job_profiles"))
        .joins('LEFT JOIN job_profiles ON job_profiles.id = ranked_job_profiles.job_profile_id')
        .order(order_options)
        .limit(options[:limit])
    end

    @build_query
  end
  # rubocop:enable Metrics/MethodLength

  def order_options
    case options[:order]
    when :growth
      { growth_type: :desc, skills_matched: :desc, skills_rarity: :asc, name: :asc }
    else
      { skills_matched: :desc, growth_type: :desc, skills_rarity: :asc, name: :asc }
    end
  end

  def job_profile_scope
    JobProfile
      .recommended
      .where.not(id: user_session.job_profile_ids)
  end

  def growth_type
    <<-SQL
    CASE WHEN growth <= - 5 THEN 1
      WHEN growth > -5 AND growth <= 5 THEN 2
      WHEN growth > 5 AND growth <= 50 THEN 3
      WHEN growth > 50 THEN 4
      ELSE 0 END
      AS growth_type
    SQL
  end
end
