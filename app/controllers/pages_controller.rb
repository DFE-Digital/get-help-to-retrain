class PagesController < ApplicationController
  def training_hub
    user_session.track_page('training_hub')
  end

  def next_steps
    user_session.track_page('next_steps')
  end

  def task_list
    if user_session.job_profile_skills?
      current_job = JobProfile.find(user_session.job_profile_ids.first)

      @skills_summary_path = skills_path(job_profile_id: current_job.slug)
    else
      @skills_summary_path = check_your_skills_path
    end
  end

  def location_eligibility
    return redirect_to_pid_or_task_list if user_session.postcode.present?

    track_event(:pages_location_eligibility_search, search: postcode) if postcode.present?
    @search = CourseGeospatialSearch.new(postcode: postcode)
    if postcode && @search.valid?
      user_session.postcode = postcode

      location_eligibility_through_courses
    end
  rescue CourseGeospatialSearch::GeocoderAPIError
    redirect_to postcode_search_error_path
  end

  private

  def postcode
    eligibility_params[:postcode]
  end

  def eligibility_params
    params.permit(:postcode)
  end

  def location_eligibility_through_courses
    if @search.find_courses.any?
      redirect_to_pid_or_task_list
    else
      redirect_to(location_ineligible_path)
    end
  end

  def redirect_to_pid_or_task_list
    redirect_to helpers.pid_step || task_list_path
  end
end
