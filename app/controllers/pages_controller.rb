class PagesController < ApplicationController
  def action_plan
    @skills = user_skill_ids.present? ? Skill.find(user_skill_ids).pluck(:name) : []

    redirect_unless_target_job
  end

  def task_list
    @skills_summary_path = user_session.job_profile_skills? ? skills_path : check_your_skills_path
  end

  private

  def user_skill_ids
    @user_skill_ids ||= user_session.skill_ids.uniq
  end
end
