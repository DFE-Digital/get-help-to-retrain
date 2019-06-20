class JobProfile < ApplicationRecord
  has_many :job_profile_categories
  has_many :job_profile_skills
  has_many :categories, through: :job_profile_categories, inverse_of: :job_profiles
  has_many :skills, through: :job_profile_skills, inverse_of: :job_profiles

  SALARY_MIN_XPATH = "//div[@id='Salary']//p[@class='dfc-code-jpsstarter']".freeze
  SALARY_MAX_XPATH = "//div[@id='Salary']//p[@class='dfc-code-jpsexperienced']".freeze
  WORKING_HOURS_XPATH = "//div[@id='WorkingHours']//p[@class='dfc-code-jphours']".freeze
  WORKING_HOURS_PATTERNS_XPATH = "//div[@id='WorkingHoursPatterns']//p[@class='dfc-code-jpwpattern']".freeze

  def self.search(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.import(slug, url)
    find_or_create_by(slug: slug) do |job_profile|
      job_profile.update(source_url: url, name: slug.titleize)
    end
  end

  def scrape
    scraper = JobProfileScraper.new
    scraped = scraper.scrape(source_url)

    update(name: scraped['title'], description: scraped['description'], content: scraped['body'])
    self.skills = Skill.import(scraped['skills'])
  end

  def salary
    {
      min: html_body.xpath(SALARY_MIN_XPATH).children[0].text.strip,
      max: html_body.xpath(SALARY_MAX_XPATH).children[0].text.strip
    }
  end

  def working_hours
    html_body.xpath(WORKING_HOURS_XPATH)
             .children[0]
             .text
             .strip
             .gsub('to', '-')
             .delete(' ')
  end

  def working_hours_patterns
    html_body.xpath(WORKING_HOURS_PATTERNS_XPATH)
             .children[0]
             .text
             .strip
             .capitalize
  end

  private

  def html_body
    @html_body ||= Nokogiri::HTML(content)
  end
end
