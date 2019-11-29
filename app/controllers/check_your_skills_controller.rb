class CheckYourSkillsController < ApplicationController
  def index
    redirect_to(skills_path) if user_session.job_profiles_cap_reached?

    @job_profile_search = JobProfileSearch.new(term: search, profile_ids_to_exclude: profile_ids_to_exclude)

    redirect_to(results_check_your_skills_path(search: search)) if search && @job_profile_search.valid?
  end

  def results
    redirect_to(skills_path) if user_session.job_profiles_cap_reached?

    track_event(:check_your_skills_index_search, search) if search.present?

    @job_profile_search = JobProfileSearch.new(term: search, profile_ids_to_exclude: profile_ids_to_exclude)
    @job_profiles = Kaminari.paginate_array(@job_profile_search.search).page(params[:page])

    spell_check_searched_term
  end

  private

  def profile_ids_to_exclude
    user_session.job_profile_ids
  end

  def search
    job_profile_params[:search]
  end

  def job_profile_params
    params.permit(:search)
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
