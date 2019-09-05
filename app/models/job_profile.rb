class JobProfile < PrimaryActiveRecordBase
  has_many :job_profile_categories
  has_many :job_profile_skills
  has_many :categories, through: :job_profile_categories, inverse_of: :job_profiles
  has_many :skills, through: :job_profile_skills, inverse_of: :job_profiles

  has_and_belongs_to_many :related_job_profiles,
                          class_name: 'JobProfile',
                          join_table: :related_job_profiles,
                          foreign_key: :job_profile_id,
                          association_foreign_key: :related_job_profile_id

  scope :recommended, -> { where(recommended: true) }
  scope :excluded, -> { where(recommended: false) }

  def self.find_by_name(name)
    where('lower(name) = ?', name.downcase).first
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
    self.related_job_profiles = JobProfile.where(slug: scraped.delete('related_profiles') - [slug])

    update!(scraped)
  end

  def with_skills(skill_ids)
    {
      profile_id: id,
      profile_slug: slug,
      name: name,
      skills: skills.each_with_object({}) { |skill, hash| hash[skill.id] = skill.name }
                    .slice(*skill_ids)
    }
  end
end
