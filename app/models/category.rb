class Category < PrimaryActiveRecordBase
  has_many :job_profile_categories
  has_many :job_profiles, through: :job_profile_categories, inverse_of: :categories
  scope :by_name, -> { order(:name) }

  def self.import(slug, url)
    find_or_create_by(slug: slug) do |category|
      category.update(source_url: url, name: slug.titleize)
    end
  end

  def scrape
    scraper = CategoryScraper.new
    scraped = scraper.scrape(source_url)

    update(name: scraped['title'])
    self.job_profiles = JobProfile.where(slug: scraper.job_profile_slugs)
  end
end
