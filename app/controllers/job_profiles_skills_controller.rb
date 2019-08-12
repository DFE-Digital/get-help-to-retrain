class JobProfilesSkillsController < ApplicationController
  def index
    skills_builder.build
    if skills_valid?
      redirect_to(
        skills_path(job_profile_id: skills_params[:job_profile_id], search: skills_params[:search])
      )
    else
      render('job_profiles/skills/index')
    end
  end

  private

  def job_profile
    @job_profile ||= JobProfileDecorator.new(
      JobProfile.find_by(slug: skills_params[:job_profile_id])
    )
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
end
