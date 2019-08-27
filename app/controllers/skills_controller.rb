class SkillsController < ApplicationController
  def index
    if Flipflop.skills_builder?
      show_skills_builder
    elsif Flipflop.skills_builder_v2?
      show_skills_builder_v2
    else
      @skills = job_profile.skills
    end
  end

  private

  # Skills Builder v1 methods
  def job_profile
    @job_profile ||= JobProfileDecorator.new(
      JobProfile.find_by(slug: skills_params[:job_profile_id])
    )
  end

  def skill_ids_for_job_profile
    @skill_ids_for_job_profile ||= user_session.skill_ids_for_profile(job_profile.id)
  end

  def skills_params
    params.permit(:job_profile_id)
  end

  def job_profile_and_skills_present
    job_profile.present? && skill_ids_for_job_profile.present?
  end

  def show_skills_builder
    return redirect_to task_list_path unless job_profile_and_skills_present

    user_session.store_at(key: :current_job_id, value: job_profile.id)

    @skills = Skill.find(skill_ids_for_job_profile)

    track_event(:skills_index_selected, job_profile.slug => skill_ids_for_job_profile)

    render 'skills/v2/index'
  end

  # Skills Builder v2 methods
  def job_profiles
    @job_profiles ||= JobProfile.includes(:skills).where(id: user_session.job_profile_ids)
  end

  def show_skills_builder_v2
    return redirect_to task_list_path unless job_profiles.any?

    @job_profiles_with_skills ||= job_profiles.map { |job_profile|
      skill_ids_from_session = user_session.skill_ids_for_profile(job_profile.id)

      next unless skill_ids_from_session.present?

      job_profile.with_skills(skill_ids_from_session)
    }.compact

    render 'skills/v3/index'
  end
end
