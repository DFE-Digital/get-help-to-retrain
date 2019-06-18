class JobProfilesController < ApplicationController
  def search
    @job_categories = Category.with_job_profiles
  end

  def index
    @job_profiles = JobProfile.search(job_profile_params[:name])
  end

  private

  def job_profile_params
    params.permit(:name)
  end
end
