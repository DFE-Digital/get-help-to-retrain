class PagesController < ApplicationController
  def action_plan
    redirect_unless_target_job
  end

  def task_list
    if user_session.job_profile_skills?
      current_job = JobProfile.find(user_session.job_profile_ids.first)

      @skills_summary_path = skills_path(job_profile_id: current_job.slug)
    else
      @skills_summary_path = check_your_skills_path
    end
  end
end
