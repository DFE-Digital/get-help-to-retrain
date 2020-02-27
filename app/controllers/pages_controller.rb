class PagesController < ApplicationController
  def action_plan
    redirect_unless_target_job
  end

  def task_list
    @skills_summary_path = user_session.job_profile_skills? ? skills_path : check_your_skills_path
  end

  def offers_near_me
    @offers_content = Strapi::ContentTypes::OfferContentType.new.content
  end
end
