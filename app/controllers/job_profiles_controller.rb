class JobProfilesController < ApplicationController
  include SearchableJobProfile

  def index
    return redirect_to task_list_path unless user_session.job_profile_skills?

    build_job_profile_search

    redirect_to_results_if_search_term_provided
  end

  def results
    return redirect_to task_list_path unless user_session.job_profile_skills?

    track_event(:job_profiles_index_search, search: search) if search.present?

    build_job_profile_search
    @results = job_profile_search_results
    @scores = SkillsMatcher.new(user_session).job_profile_scores
    @job_profiles = JobProfileDecorator.decorate(@results)
  end

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
