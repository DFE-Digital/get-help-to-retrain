class JobProfilesSkillsController < ApplicationController
  def index
    if profile_skills_not_editable? && user_session.job_profiles_cap_reached?
      redirect_to skills_path
    else
      skills_builder.build

      if skills_valid?
        track_selections(:skills_builder, selected: selected_skills, unselected: unselected_skills)

        return redirect_to skills_path
      end

      render('job_profiles/skills/index')
    end
  end

  private

  def job_profile
    @job_profile ||= JobProfile.find_by(slug: skills_params[:job_profile_id])
  end

  def skills_builder
    @skills_builder ||= SkillsBuilder.new(
      skills_params: skills_params[:skill_ids],
      job_profile: job_profile,
      user_session: user_session
    )
  end

  def skills_valid?
    skills_params[:skill_ids].present? && skills_builder.valid?
  end

  def skills_params
    params.permit(:job_profile_id, :search, skill_ids: [])
  end

  def profile_skills_not_editable?
    user_session.job_profile_ids.exclude?(job_profile.id)
  end

  def available_skills
    @available_skills ||= job_profile.skills.each_with_object({}) do |skill, hash|
      hash[skill.id.to_s] = skill.name
    end
  end

  def user_skill_ids
    @user_skill_ids ||= skills_params[:skill_ids].reject(&:empty?)
  end

  def selected_skills
    {
      label: "#{job_profile.name} - Ticked",
      values: available_skills.slice(*user_skill_ids).values
    }
  end

  def unselected_skills
    {
      label: "#{job_profile.name} - Unticked",
      values: available_skills.except(*user_skill_ids).values
    }
  end
end
