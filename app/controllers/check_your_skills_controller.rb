class CheckYourSkillsController < ApplicationController
  def index
    redirect_to(skills_path) if Flipflop.skills_builder_v2? && user_session.job_profiles_cap_reached?

    @job_profile_search = JobProfileSearch.new(term: search, profile_ids_to_exclude: profile_ids_to_exclude)
    redirect_to(results_check_your_skills_path(search: search)) if search && @job_profile_search.valid?
  end

  def results
    redirect_to(skills_path) if Flipflop.skills_builder_v2? && user_session.job_profiles_cap_reached?

    track_event(:check_your_skills_index_search, search: search) if search.present?

    @job_profile_search = JobProfileSearch.new(term: search, profile_ids_to_exclude: profile_ids_to_exclude)
    @job_profiles = @job_profile_search.search.page(params[:page])
  end

  private

  def profile_ids_to_exclude
    return [] unless Flipflop.skills_builder_v2?

    user_session.job_profile_ids
  end

  def search
    job_profile_params[:search]
  end

  def job_profile_params
    params.permit(:search)
  end
end
