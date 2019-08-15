class SkillsController < ApplicationController
  def index
    if Flipflop.skills_builder?
      return redirect_to task_list_path unless job_profile_and_skills_present

      session[:current_job_id] = job_profile.id
      @skills = Skill.find(skill_ids)

      render 'index_v2'
    else
      @skills = job_profile.skills
    end
  end

  private

  def job_profile
    @job_profile ||= JobProfileDecorator.new(
      JobProfile.find_by(slug: skills_params[:job_profile_id])
    )
  end

  def skill_ids
    session.fetch(:job_profile_skills, {})[job_profile.id.to_s] || []
  end

  def skills_params
    params.permit(:job_profile_id)
  end

  def job_profile_and_skills_present
    job_profile.present? && skill_ids.present?
  end
end
