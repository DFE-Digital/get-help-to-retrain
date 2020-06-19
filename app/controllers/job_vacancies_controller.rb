class JobVacanciesController < ApplicationController
  DISTANCE = [
    ['Up to 10 miles', '10'], ['Up to 20 miles', '20'], ['Up to 30 miles', '30'], ['Up to 40 miles', '40']
  ].freeze

  def index
    return redirect_to task_list_path unless target_job.present?

    @alternative_job_titles = alternative_job_titles

    track_search_filters
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

  def outcode
    UKPostcode.parse(postcode).outcode
  end

  def alternative_job_title
    @alternative_job_title ||= job_vacancies_params[:alternative_job_title]
  end

  def alternative_job_titles
    return unless target_job.alternative_titles.present?

    target_job.alternative_titles.split(',').map(&:strip) - [alternative_job_title]
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
    params.permit(:postcode, :page, :distance, :alternative_job_title)
  end

  def jobs
    @job_vacancy_search.jobs.map { |j| JobVacancyDecorator.new(j) }
  end

  def job_vacancy_search
    options = {
      postcode: postcode,
      name: alternative_job_title.present? ? alternative_job_title : target_job.name,
      page: job_vacancies_params[:page],
      distance: job_vacancies_params[:distance]
    }.compact

    @job_vacancy_search ||= JobVacancySearch.new(options)
  end

  def track_search_filters
    track_event(:jobs_near_me_index_search, outcode) if postcode.present?

    track_filter_for(
      key: :filter_job_vacancies,
      parameter: job_vacancies_params[:distance],
      value_mapping: DISTANCE,
      label: 'events.job_distance_filter'
    )
  end
end
