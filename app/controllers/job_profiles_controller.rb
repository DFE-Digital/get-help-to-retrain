class JobProfilesController < ApplicationController
  def show
    @job_profile = JobProfileDecorator.new(resource)
  end

  private

  def resource
    @resource ||= JobProfile.find_by(slug: params[:id])
  end
end
