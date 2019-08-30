class JobProfilesSkillsController < ApplicationController
  def index
    if Flipflop.skills_builder_v2? && profile_skills_not_editable? && user_session.job_profiles_cap_reached?
      redirect_to_profile_skills_page
    else
      skills_builder.build

      return redirect_to_profile_skills_page if skills_valid?

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
      user_session: session
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

  def redirect_to_profile_skills_page
    redirect_to(
      skills_path(job_profile_id: skills_params[:job_profile_id], search: skills_params[:search])
    )
  end
end
