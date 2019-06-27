class CheckYourSkillsController < ApplicationController
  def results
    @job_profiles = JobProfile.search(job_profile_params[:name]).map do |job_profile|
      JobProfileDecorator.new(job_profile)
    end
  end

  private

  def job_profile_params
    params.permit(:name)
  end
end
