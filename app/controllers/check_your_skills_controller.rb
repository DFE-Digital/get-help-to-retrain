class CheckYourSkillsController < ApplicationController
  def results
    @job_profiles = JobProfile.search(job_profile_params[:name])
  end

  private

  def job_profile_params
    params.permit(:name)
  end
end
