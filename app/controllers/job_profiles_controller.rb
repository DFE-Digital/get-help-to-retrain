class JobProfilesController < ApplicationController
  def show
    @job_profile = JobProfileDecorator.new(resource)
    @job_vacancy_count = job_vacancy_count
    @skills_to_develop = @job_profile.skills - user_skills
    @existing_skills = @job_profile.skills & user_skills
  end

  def target
    user_session.target_job_id = resource.id
    redirect_to helpers.action_plan_or_questions_path
  end

  def destroy
    user_session.remove_job_profile(resource.id)

    redirect_to(
      skills_path, notice: t('.notice', name: resource.name.downcase)
    )
  end

  private

  def resource
    @resource ||= JobProfile.find_by(slug: job_profile_params[:id])
  end

  def job_profile_params
    params.permit(:search, :id)
  end

  def job_vacancy_count
    JobVacancySearch.new(
      name: resource.name,
      postcode: user_session.postcode
    ).count
  rescue FindAJobService::APIError
    nil
  end

  def user_skills
    @user_skills ||= Skill.find(user_session.skill_ids)
  end
end
