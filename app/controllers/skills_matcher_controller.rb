class SkillsMatcherController < ApplicationController
  def index
    return redirect_to task_list_path unless user_session.job_profile_skills?

    user_session.track_page('skills_matcher_index')

    @results = Kaminari.paginate_array(skills_matcher.match).page(params[:page])
    @scores = skills_matcher.job_profile_scores
    @job_profiles = @results.map { |job_profile| JobProfileDecorator.new(job_profile) }
  end

  private

  def skills_matcher
    @skills_matcher ||= SkillsMatcher.new(user_session)
  end
end
