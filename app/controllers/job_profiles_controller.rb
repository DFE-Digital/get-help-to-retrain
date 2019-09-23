class JobProfilesController < ApplicationController
  def show
    @job_profile = JobProfileDecorator.new(resource)
  end

  def destroy
    user_session.remove_job_profile(resource.id)

    query_params = { search: job_profile_params[:search] }
    query_params[:job_profile_id] = job_profile_params[:job_profile_id] unless user_session.job_profile_skills?

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
end
