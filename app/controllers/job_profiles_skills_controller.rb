class JobProfilesSkillsController < ApplicationController
  def index
    if skills_valid?
      redirect skills_path
    else
      @skills = job_profile.skills
      @skills.errors.add(:postcode, 'Select at least one skill')
    end
  end

  def current_job_skills

  end

  def your_skills
    @skills = job_profile.skills
  end

  private

  def job_profile
    @job_profile ||= JobProfileDecorator.new(
      JobProfile.find_by(slug: params[:job_profile_id])
    )
  end

  def skills_params
    params.permit(:job_profile_id, skill_ids: [])
  end

  def skills_valid?
    skills_params[:skill_ids].present? && skills_params[:skill_ids].count > 1
  end
end
