class JobProfilesController < ApplicationController
  def show
    @job_profile = JobProfileDecorator.new(job_profile)
  end

  private

  def job_profile
    @job_profile ||= JobProfile.find_by(slug: params[:id])
  end
end
