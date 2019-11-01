class JobProfileImportService
  GROWTH_COLUMN_HEADINGS = {
    soc: 'SOCCode',
    extended_soc: 'NCS SOCCode',
    name: 'Description',
    growth: 'Recent growth (% change to March 2018)'
  }.freeze

  ADDITIONAL_DATA_COLUMN_HEADINGS = {
    slug: 'UrlName',
    hidden_titles: 'HiddenAlternativeTitle',
    specialism: 'JobProfileSpecialism'
  }.freeze

  def initialize
    not_production!
    @errors = []
  end

  def import_growth(filename)
    file = Roo::Spreadsheet.open(filename)
    sheet = file.sheet('Sheet1')

    sheet.each(GROWTH_COLUMN_HEADINGS) do |data|
      next if data == GROWTH_COLUMN_HEADINGS

      update_job_profile(data, :name)
    end
  end

  def import_growth_stats
    {
      job_profiles_total: JobProfile.count,
      job_profiles_with_growth: JobProfile.where.not(growth: nil).count,
      job_profiles_missing_growth: JobProfile.where(growth: nil).count,
      errors: @errors.count
    }
  end

  def import_additional_data(filename)
    file = Roo::Spreadsheet.open(filename)
    sheet = file.sheet('JobProfile')

    sheet.each(ADDITIONAL_DATA_COLUMN_HEADINGS) do |data|
      next if data == ADDITIONAL_DATA_COLUMN_HEADINGS

      update_job_profile(data, :slug)
    end
  end

  def import_additional_data_stats
    {
      job_profiles_total: JobProfile.count,
      job_profiles_with_hidden_titles: JobProfile.where.not(hidden_titles: nil).count,
      job_profiles_missing_hidden_titles: JobProfile.where(hidden_titles: nil).count,
      job_profiles_with_specialism: JobProfile.where.not(specialism: nil).count,
      job_profiles_missing_specialism: JobProfile.where(specialism: nil).count,
      errors: @errors.count
    }
  end

  private

  def update_job_profile(data, key)
    value = data.delete(key).strip
    job_profile = JobProfile.find_by(key => value)
    if job_profile.present?
      data.each { |k, v| data[k] = v.presence }
      job_profile.update(data)
    else
      print "Failed to find matching job profile for \"#{value}\""
      @errors << value
    end
  end

  def not_production!
    raise 'Not to be run in production' if Rails.env.production?
  end
end
