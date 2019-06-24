class ExploreOccupationsController < ApplicationController
  def index
    @categories = Category.with_job_profiles.by_name
  end

  def results
    @job_profiles = JobProfile.search(job_profile_params[:name])
  end

  private

  def job_profile_params
    params.permit(:name)
  end
end
