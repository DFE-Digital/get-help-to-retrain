class SkillsMatcherController < ApplicationController
  def index
    @results = Kaminari.paginate_array(skills_matcher.match).page(params[:page]).per(10)
    @scores = skills_matcher.job_profile_scores
    @job_profiles = @results.map { |job_profile|
      JobProfileDecorator.new(job_profile)
    }
  end

  private

  def skills_matcher
    @skills_matcher ||= SkillsMatcher.new(user_session: session)
  end
end
