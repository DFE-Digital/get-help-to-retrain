class JobProfileSearchService
  SEARCH_COLUMN_HEADINGS = {
    word: 'Word',
    alternatives: 'alternatives',
    type: 'word type'
  }.freeze

  def initialize
    not_production!
  end

  def import(filename)
    file = Roo::Spreadsheet.open(filename)
    sheet = file.sheet('Sheet1')

    JobProfile.update_all(hierarchy: nil, sector: nil)

    sheet.each(SEARCH_COLUMN_HEADINGS) do |data|
      next if data == SEARCH_COLUMN_HEADINGS

      update_job_profile(data)
    end
  end

  def import_stats
    {
      job_profiles_with_hierarchy: JobProfile.where.not(hierarchy: nil).count,
      job_profiles_with_sector: JobProfile.where.not(sector: nil).count,
      job_profiles_missing_search_value: JobProfile.where(
        hierarchy: nil,
        sector: nil
      ).count
    }
  end

  private

  def update_job_profile(data)
    return if %w[doubtful meaningless].include?(data[:type])

    words = build_word_array(data)
    job_profiles = job_profiles_with(words)

    update_job_profiles!(job_profiles, data[:type], words) if job_profiles.any?
  end

  def build_word_array(data)
    alternatives = data[:alternatives]&.split(', ')

    [data[:word], alternatives].flatten.compact
  end

  def job_profiles_with(words)
    query = words.map { |s| "%#{s}%" }

    JobProfile
      .where(
        'name ILIKE ANY (ARRAY[?]) OR alternative_titles ILIKE ANY (ARRAY[?])',
        query,
        query
      )
  end

  def update_job_profiles!(job_profiles, type, words)
    word_list = words.join(', ')
    if type == 'hierarchy'
      job_profiles.each { |j| j.update(hierarchy: [j.hierarchy, word_list].compact.join(', ')) }
    elsif type == 'sector/subject'
      job_profiles.each { |j| j.update(sector: [j.sector, word_list].compact.join(', ')) }
    end
  end

  def not_production!
    raise 'Not to be run in production' if Rails.env.production?
  end
end
