class PagesController < ApplicationController
  include Secured

  def action_plan
    redirect_to task_list_path unless target_job.present?
  end

  def task_list
    @auth0_user_info = session[:userinfo]

    if user_session.job_profile_skills?
      current_job = JobProfile.find(user_session.job_profile_ids.first)

      @skills_summary_path = skills_path(job_profile_id: current_job.slug)
    else
      @skills_summary_path = check_your_skills_path
    end
  end
end
