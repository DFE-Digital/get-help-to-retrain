class JobProfilesController < ApplicationController
  before_action :decorate_job_profile, on: %i[show skills]

  private

  def job_profile
    @job_profile ||= JobProfile.find_by(slug: params[:id])
  end

  def decorate_job_profile
    @job_profile = JobProfileDecorator.new(job_profile)
  end
end
