class SkillsMatcherController < ApplicationController
  def index
    return redirect_to task_list_path unless user_session.job_profile_skills?

    @results = Kaminari.paginate_array(skills_matcher.match).page(params[:page])
    @scores = skills_matcher.job_profile_scores
    @job_profiles = JobProfileDecorator.decorate(@results)
  end

  private

  def skills_matcher
    @skills_matcher ||= SkillsMatcher.new(user_session, limit: 50)
  end
end
