class JobProfilesController < ApplicationController
  def index
    @job_profiles = JobProfile.search(job_profile_params[:name])
  end

  private

  def job_profile_params
    params.require(:job_profile).permit(:name)
  end
end
