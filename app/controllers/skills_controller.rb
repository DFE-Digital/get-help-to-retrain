class SkillsController < ApplicationController
  def index
    @job_profiles_with_skills = job_profiles.map { |job_profile|
      skill_ids_from_session = user_session.skill_ids_for_profile(job_profile.id)

      next unless skill_ids_from_session.present?

      job_profile.with_skills(skill_ids_from_session)
    }.compact
  end

  private

  def job_profiles
    @job_profiles ||= JobProfile.includes(:skills).find(user_session.job_profile_ids)
  end
end
