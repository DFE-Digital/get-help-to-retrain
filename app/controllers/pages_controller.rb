class PagesController < ApplicationController
  def action_plan
    redirect_unless_target_job
  end

  def task_list
    @skills_summary_path = user_session.job_profile_skills? ? skills_path : check_your_skills_path
  end

  def admin_sign_in
    return redirect_to root_path if admin_current_user.present?

    render layout: 'admin/application'
  end
end
