class JobVacancySearch
  include ActiveModel::Validations

  attr_reader :postcode, :name, :page_relative_to_api, :distance
  validates :postcode, presence: { message: I18n.t('courses.no_postcode_error') }
  validates :postcode, postcode: true, allow_blank: true

  def initialize(postcode:, name:, page: 1, distance: 20)
    @postcode = postcode
    @name = name
    @page_relative_to_api = page_relative_to_api_from(page)
    @distance = distance
  end

  def jobs
    return [] unless valid? && job_vacancies_response['jobs'].present?

    job_vacancies_response
      .dig('jobs')
      .map { |job| JobVacancy.new(job) }
  end

  def count
    return unless valid?

    job_vacancies_response.dig('pager', 'total_entries')
  end

  private

  def page_relative_to_api_from(page)
    return 1 unless page.present?

    ((page.to_i * 10.0) / 50).ceil
  end

  def job_vacancies_response
    @job_vacancies_response ||= FindAJobService.new.job_vacancies(
      postcode: postcode,
      name: name,
      page: page_relative_to_api,
      distance: distance
    )
  end
end
