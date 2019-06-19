class JobProfilesController < ApplicationController
  def index
    @job_profiles = JobProfile.search(job_profile_params[:name])
  end

  def show
    @job_profile = JobProfileDecorator.new(job_profile)
  end

  private

  def job_profile_params
    params.require(:job_profile).permit(:name)
  end

  def job_profile
    @job_profile ||= JobProfile.find_by(slug: params[:id])
  end
end
