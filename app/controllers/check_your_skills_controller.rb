class CheckYourSkillsController < ApplicationController
  def results
    track_event :check_your_skills_index_search, search: search
    @job_profiles = JobProfile.search(search).page(params[:page])
  end

  private

  def search
    job_profile_params[:search]
  end

  def job_profile_params
    params.permit(:search)
  end
end
