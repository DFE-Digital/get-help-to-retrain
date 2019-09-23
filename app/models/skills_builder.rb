class SkillsBuilder
  include ActiveModel::Validations

  attr_reader :skills_params, :job_profile, :user_session
  validate :skill_ids_presence

  def initialize(skills_params:, job_profile:, user_session:)
    @skills_params = skills_params
    @job_profile = job_profile
    @user_session = user_session
  end

  def build
    return unless skills_params.present? && valid?

    user_session.set_skills_ids_for_profile(job_profile.id, formatted_skill_params)
  end

  def skill_ids
    @skill_ids ||= begin
      return [] if skills_params.present? && !valid?

      user_session.job_profile_skills[job_profile.id.to_s] ||
        job_profile.skills.pluck(:id)
    end
  end

  private

  def skill_ids_presence
    errors.add(:skills, I18n.t('skills.invalid_skills_selected_error')) unless skills_selected?
  end

  def formatted_skill_params
    @formatted_skill_params ||= skills_params.reject(&:empty?).map(&:to_i)
  end

  def skills_selected?
    formatted_skill_params.any?
  end
end
