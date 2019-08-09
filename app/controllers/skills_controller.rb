class SkillsController < ApplicationController
  def index
    if Flipflop.skills_builder?
      job_profile
      @skills = Skill.find(session[:skill_ids])
      render 'index_v2'
    else
      @skills = job_profile.skills
    end
  end

  private

  def job_profile
    @job_profile ||= JobProfileDecorator.new(
      JobProfile.find_by(slug: skills_params[:job_profile_id])
    )
  end

  def skills_params
    params.permit(:job_profile_id)
  end
end
