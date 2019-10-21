class JobVacanciesController < ApplicationController
  def index
    return redirect_to task_list_path unless target_job.present?

    @job_vacancy_search = JobVacancySearch.new(
      postcode: postcode,
      name: target_job.name,
      page: job_vacancies_params[:page]
    )

    @job_vacancies = job_vacancies
  end

  private

  def postcode
    @postcode ||= job_vacancies_params[:postcode] || user_session.postcode
  end

  def job_vacancies
    Kaminari
      .paginate_array(jobs, total_count: @job_vacancy_search.count)
      .page(job_vacancies_params[:page])
      .per(50)
  end

  def job_vacancies_params
    params.permit(:postcode, :page)
  end

  def jobs
    @job_vacancy_search.jobs.map { |j| JobVacancyDecorator.new(j) }
  end
end
