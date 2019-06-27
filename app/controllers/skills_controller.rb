class SkillsController < ApplicationController
  def index
    @skills = job_profile.skills
  end

  private

  def job_profile
    @job_profile ||= JobProfileDecorator.new(
      JobProfile.find_by(slug: params[:job_profile_id])
    )
  end
end
