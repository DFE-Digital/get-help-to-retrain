class JobVacanciesController < ApplicationController
  DISTANCE = [
    ['Up to 10 miles', '10'], ['Up to 20 miles', '20'], ['Up to 30 miles', '30'], ['Up to 40 miles', '40']
  ].freeze

  def index
    return redirect_to task_list_path unless target_job.present?

    persist_valid_filters_on_session

    @job_vacancies = job_vacancies
  rescue FindAJobService::APIError
    redirect_to jobs_near_me_error_path
  end

  private

  def postcode
    @postcode ||= job_vacancies_params[:postcode] || user_session.postcode
  end

  def distance
    @distance ||= job_vacancies_params[:distance] || user_session.distance
  end

  def persist_valid_filters_on_session
    return unless job_vacancy_search.valid?

    user_session.postcode = postcode if postcode
    user_session.distance = distance if distance
  end

  def job_vacancies
    Kaminari
      .paginate_array(jobs, total_count: job_vacancy_search.count)
      .page(job_vacancies_params[:page])
      .per(50)
  end

  def job_vacancies_params
    params.permit(:postcode, :page, :distance)
  end

  def jobs
    @job_vacancy_search.jobs.map { |j| JobVacancyDecorator.new(j) }
  end

  def job_vacancy_search
    @job_vacancy_search ||= JobVacancySearch.new(
      postcode: postcode,
      name: target_job.name,
      page: job_vacancies_params[:page],
      distance: job_vacancies_params[:distance]
    )
  end
end
