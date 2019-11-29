module SearchableJobProfile
  extend ActiveSupport::Concern

  private

  def build_job_profile_search
    @job_profile_search = JobProfileSearch.new(term: search, profile_ids_to_exclude: profile_ids_to_exclude)
  end

  def job_profile_search_results
    Kaminari.paginate_array(@job_profile_search.search).page(params[:page])
  end

  def profile_ids_to_exclude
    user_session.job_profile_ids
  end

  def search
    job_profile_params[:search]
  end

  def redirect_to_results_if_search_term_provided
    redirect_to(action: :results, search: search) if search && @job_profile_search.valid?
  end
end
