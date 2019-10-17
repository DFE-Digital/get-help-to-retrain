class JobProfilesController < ApplicationController
  def show
    @job_profile = JobProfileDecorator.new(resource)
    @job_vacancy_count = job_vacancy_count if user_session.postcode.present?
  end

  def update
    user_session.target_job_id = resource.id

    redirect_to action_plan_path
  end

  def destroy
    user_session.remove_job_profile(resource.id)

    redirect_to(
      skills_path(query_params)
    )
  end

  private

  def resource
    @resource ||= JobProfile.find_by(slug: job_profile_params[:id])
  end

  def job_profile_params
    params.permit(:job_profile_id, :search, :id)
  end

  def query_params
    # TODO: this is to support skills removal. Revisit after fixing navigation
    query = { search: job_profile_params[:search] }
    query[:job_profile_id] = job_profile_params[:job_profile_id] unless user_session.job_profile_skills?

    query
  end

  def job_vacancy_count
    FindAJobService.new.job_vacancy_count(
      name: resource.name,
      postcode: user_session.postcode,
      distance: 20
    )
  end
end
