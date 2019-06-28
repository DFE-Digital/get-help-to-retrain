class JobProfile < ApplicationRecord
  has_many :job_profile_categories
  has_many :job_profile_skills
  has_many :categories, through: :job_profile_categories, inverse_of: :job_profiles
  has_many :skills, through: :job_profile_skills, inverse_of: :job_profiles

  def self.search(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.import(slug, url)
    find_or_create_by(slug: slug) do |job_profile|
      job_profile.update(source_url: url, name: slug.titleize)
    end
  end

  def scrape(scraper = JobProfileScraper.new)
    scraped = scraper.scrape(source_url)

    self.name = scraped.delete('title')
    self.skills = Skill.import scraped.delete('skills')
    update!(scraped)
  end
end
