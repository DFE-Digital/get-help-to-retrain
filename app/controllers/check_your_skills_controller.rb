class CheckYourSkillsController < ApplicationController
  include SearchableJobProfile

  def index
    redirect_to(skills_path) if user_session.job_profiles_cap_reached?

    build_job_profile_search

    redirect_to_results_if_search_term_provided
  end

  def results
    redirect_to(skills_path) if user_session.job_profiles_cap_reached?

    track_event(:check_your_skills_index_search, search) if search.present?

    build_job_profile_search
    @job_profiles = job_profile_search_results

    spell_check_searched_term
  end

  private

  def job_profile_params
    params.permit(:search)
  end
end
