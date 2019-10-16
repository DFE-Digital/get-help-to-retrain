class SkillsController < ApplicationController
  def index
    return redirect_to task_list_path unless
      skills_params[:job_profile_id].present? ||
      (job_profiles.any? && user_session.skill_ids.any?)

    @job_profiles_with_skills ||= job_profiles.map { |job_profile|
      skill_ids_from_session = user_session.skill_ids_for_profile(job_profile.id)

      next unless skill_ids_from_session.present?

      job_profile.with_skills(skill_ids_from_session)
    }.compact

    render 'skills/index'
  end

  private

  def job_profiles
    @job_profiles ||= JobProfile.includes(:skills).find(user_session.job_profile_ids)
  end

  def skills_params
    params.permit(:job_profile_id)
  end
end
