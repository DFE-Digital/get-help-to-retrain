class JobVacancySearch
  include ActiveModel::Validations

  attr_reader :postcode, :name, :page, :distance
  # TODO: Amend with correct error message
  validates :postcode, presence: { message: I18n.t('courses.no_postcode_error') }
  validates :postcode, postcode: true, allow_blank: true

  def initialize(postcode:, name:, page: 1, distance: 20)
    @postcode = postcode
    @name = name
    @page = page
    @distance = distance
  end

  def jobs
    return [] unless valid?

    job_vacancies_response
      .fetch('jobs', [])
      .map { |job| JobVacancy.new(job) }
  end

  def count
    return unless valid?

    job_vacancies_response.dig('pager', 'total_entries')
  end

  private

  def job_vacancies_response
    @job_vacancies_response ||= FindAJobService.new.job_vacancies(
      postcode: postcode,
      name: name,
      page: page,
      distance: distance
    )
  end
end
