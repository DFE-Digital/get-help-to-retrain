class ExploreOccupationsController < ApplicationController
  def index
    @categories = Category.with_job_profiles.by_name
  end

  def results
    @search_results = JobProfile.search(job_profile_params[:search]).includes(:categories).page(params[:page])
    @job_profiles = @search_results.map { |job_profile|
      JobProfileDecorator.new(job_profile)
    }
  end

  private

  def job_profile_params
    params.permit(:search)
  end
end
