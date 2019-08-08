class JobProfileImportService
  GROWTH_COLUMN_HEADINGS = {
    soc: 'SOCCode',
    extended_soc: 'NCS SOCCode',
    name: 'Description',
    growth: 'Recent growth (% change to March 2018)'
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

      update_job_profile(data)
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

  private

  def update_job_profile(data)
    name = data.delete(:name).strip
    job_profile = JobProfile.find_by_name(name)
    if job_profile.present?
      job_profile.update(data)
    else
      print "Failed to find matching job profile for \"#{name}\""
      @errors << name
    end
  end

  def not_production!
    raise 'Not to be run in production' if Rails.env.production?
  end
end
