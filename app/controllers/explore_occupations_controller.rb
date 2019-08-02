class ExploreOccupationsController < ApplicationController
  def index
    @categories = Category.with_job_profiles.by_name
  end

  def results
    track_event :explore_occupations_index_search, search: search
    @search_results = JobProfile.search(search).includes(:categories).page(params[:page])
    @job_profiles = @search_results.map { |job_profile|
      JobProfileDecorator.new(job_profile)
    }
  end

  private

  def search
    job_profile_params[:search]
  end

  def job_profile_params
    params.permit(:search)
  end
end
