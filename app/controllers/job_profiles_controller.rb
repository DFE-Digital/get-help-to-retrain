class JobProfilesController < ApplicationController
  include SearchableJobProfile

  def index
    return redirect_to task_list_path unless user_session.job_profile_skills?

    build_job_profile_search

    redirect_to_results_if_search_term_provided
  end

  def results
    return redirect_to task_list_path unless user_session.job_profile_skills?

    track_event(:job_profiles_index_search, search) if search.present?

    build_job_profile_search
    @results = job_profile_search_results
    @scores = SkillsMatcher.new(user_session).job_profile_scores
    @job_profiles = JobProfileDecorator.decorate(@results)

    spell_check_searched_term
  end

  def show
    @job_profile = JobProfileDecorator.new(resource)
    @job_vacancy_count = job_vacancy_count
    @skills_to_develop = @job_profile.skills.names_that_exclude(user_skill_ids)
    @existing_skills = @job_profile.skills.names_that_include(user_skill_ids)
  end

  def target
    user_session.target_job_id = resource.id

    track_targetted_job(job_profile_name: resource.name)

    redirect_to helpers.action_plan_or_questions_path
  end

  def destroy
    user_session.remove_job_profile(resource.id)

    redirect_to(
      skills_path, notice: t('.notice', name: resource.name)
    )
  end

  private

  def resource
    @resource ||= JobProfile.find_by!(slug: job_profile_params[:id])
  end

  def job_profile_params
    params.permit(:search, :id)
  end

  def job_vacancy_count
    # Disabling temporarily until search improved
    # JobVacancySearch.new(
    #   name: resource.name,
    #   postcode: user_session.postcode
    # ).count
  rescue FindAJobService::APIError
    nil
  end

  def user_skill_ids
    @user_skill_ids ||= user_session.skill_ids.map(&:to_s)
  end
end
