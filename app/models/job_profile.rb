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
    slugs.map { |slug| find_by(slug: slug) }.compact
  end

  def scrape(scraper = JobProfileScraper.new)
    scraped = scraper.scrape(source_url)

    ActiveRecord::Base.transaction do
      self.name = scraped.delete('title')

      skills_to_import = Skill.import scraped.delete('skills')

      related_profiles_to_import = JobProfile.bulk_import(
        remove_value_from(
          collection: scraped.delete('related_profiles'),
          value: slug
        )
      )

      clean_related_profiles

      self.skills = skills_to_import
      self.related_job_profiles = related_profiles_to_import

      update!(scraped)
    rescue StandardError => e
      puts "Could not resume scraping, rolling back. Reason: #{e.message}"
    end
  end

  private

  def remove_value_from(collection:, value:)
    collection.delete(value) if value

    collection
  end

  def clean_related_profiles
    related_job_profiles.destroy_all
  end
end
