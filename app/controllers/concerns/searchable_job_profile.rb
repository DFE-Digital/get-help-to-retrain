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

  def spell_check_service
    @spell_check_service ||= SpellCheckService.new
  end

  def spell_check_searched_term
    return unless search.present?

    @spell_checked_search = spell_check_service.scan(search_term: search)
  rescue SpellCheckService::SpellCheckServiceError
    @spell_checked_search = nil
  end
end
