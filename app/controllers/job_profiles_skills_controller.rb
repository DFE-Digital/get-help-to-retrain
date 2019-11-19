class JobProfilesSkillsController < ApplicationController
  def index
    if profile_skills_not_editable? && user_session.job_profiles_cap_reached?
      redirect_to skills_path
    else
      skills_builder.build

      return redirect_to skills_path if skills_valid?

      render('job_profiles/skills/index')
    end
  end

  private

  def job_profile
    @job_profile ||= JobProfile.find_by(slug: skills_params[:job_profile_id])
  end

  def skills_builder
    @skills_builder ||= SkillsBuilder.new(
      skills_params: skills_params[:skill_ids],
      job_profile: job_profile,
      user_session: user_session
    )
  end

  def skills_valid?
    skills_params[:skill_ids].present? && skills_builder.valid?
  end

  def skills_params
    params.permit(:job_profile_id, :search, skill_ids: [])
  end

  def profile_skills_not_editable?
    user_session.job_profile_ids.exclude?(job_profile.id)
  end
end
