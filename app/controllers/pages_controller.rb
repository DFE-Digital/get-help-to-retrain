class PagesController < ApplicationController
  def action_plan
    redirect_unless_target_job
  end

  def task_list
    @skills_summary_path = user_session.job_profile_skills? ? skills_path : check_your_skills_path
  end

  def information_sources
    @back_url = url_parser.get_redirect_path || root_path
  end

  private

  def url_parser
    @url_parser ||= UrlParser.new(request.referer, request.host)
  end
end
