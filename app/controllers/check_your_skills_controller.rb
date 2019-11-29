class CheckYourSkillsController < ApplicationController
  include SearchableJobProfile

  def index
    redirect_to(skills_path) if user_session.job_profiles_cap_reached?

    build_job_profile_search

    redirect_to_results_if_search_term_provided
  end

  def results
    redirect_to(skills_path) if user_session.job_profiles_cap_reached?

    track_event(:check_your_skills_index_search, search: search) if search.present?

    build_job_profile_search
    @job_profiles = job_profile_search_results

    spell_check_searched_term
  end

  private

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
