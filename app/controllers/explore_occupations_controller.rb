class ExploreOccupationsController < ApplicationController
  def index
    @categories = Category.with_job_profiles.by_name
    @job_profile_search = JobProfileSearch.new(term: search)

    redirect_to(results_explore_occupations_path(search: search)) if search && @job_profile_search.valid?
  end

  def results
    track_event(:explore_occupations_index_search, search: search) if search.present?
    @job_profile_search = JobProfileSearch.new(term: search)

    @search_results = @job_profile_search.search.includes(:categories).page(params[:page])
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
