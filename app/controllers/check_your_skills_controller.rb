class CheckYourSkillsController < ApplicationController
  def results
    @job_profiles = JobProfile.search(job_profile_params[:search]).page(params[:page])
  end

  private

  def job_profile_params
    params.permit(:search)
  end
end
