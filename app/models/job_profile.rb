class JobProfile < ApplicationRecord
  has_many :job_profile_categories
  has_many :job_profile_skills
  has_many :categories, through: :job_profile_categories, inverse_of: :job_profiles
  has_many :skills, through: :job_profile_skills, inverse_of: :job_profiles

  has_and_belongs_to_many :related_job_profiles,
                          class_name: 'JobProfile',
                          join_table: :related_job_profiles,
                          foreign_key: :job_profile_id,
                          association_foreign_key: :related_job_profile_id

  def self.search(name)
    return none unless name.present?

    where('name ILIKE ?', "%#{name&.squish}%")
  end

  def self.import(slug, url)
    find_or_create_by(slug: slug) do |job_profile|
      job_profile.update(source_url: url, name: slug.titleize)
    end
  end

  def self.bulk_import(slugs)
    where(slug: slugs)
  end

  def scrape(scraper = JobProfileScraper.new)
    scraped = scraper.scrape(source_url)

    self.name = scraped.delete('title')
    self.skills = Skill.import scraped.delete('skills')
    self.related_job_profiles = JobProfile.bulk_import(scraped.delete('related_profiles') - [slug])

    update!(scraped)
  end
end
