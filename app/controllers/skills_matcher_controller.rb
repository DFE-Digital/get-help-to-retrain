class SkillsMatcherController < ApplicationController
  def index
    @results = JobProfile.all.includes(:categories).page(params[:page])
    @job_profiles = @results.map { |job_profile|
      JobProfileDecorator.new(job_profile)
    }
  end
end
