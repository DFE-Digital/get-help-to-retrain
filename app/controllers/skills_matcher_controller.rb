class SkillsMatcherController < ApplicationController
  SORT_OPTIONS = [['Skills match', :skills], ['Recent job growth', :growth]].freeze

  def index
    return redirect_to task_list_path unless user_session.job_profile_skills?

    @order = preferred_sort_order
    @results = Kaminari.paginate_array(skills_matcher.match).page(params[:page])
    @scores = skills_matcher.job_profile_scores
    @job_profiles = JobProfileDecorator.decorate(@results)
    @options = helpers.options_for_select(SORT_OPTIONS, @order)
  end

  private

  def preferred_sort_order
    user_session.skills_matcher_sort = sort if %w[skills growth].include?(sort)

    (user_session.skills_matcher_sort || 'skills').to_sym
  end

  def sort
    sort_params[:sort]
  end

  def sort_params
    params.permit(:sort)
  end

  def skills_matcher
    @skills_matcher ||= SkillsMatcher.new(user_session, limit: 50, order: @order)
  end
end
