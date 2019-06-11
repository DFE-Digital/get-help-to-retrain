class JobProfile < ApplicationRecord
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :skills

  scope :recommended, -> { where(recommended: true) }

  def self.import(url)
    slug = url.match(/job-profiles\/(.*)$/)[1]
    find_or_create_by(slug: slug) do |job_profile|
      job_profile.update(source_url: url, name: slug.titleize)
    end
  end

  def imported?
    content.present?
  end

  def scrape
    page = HTTParty.get(source_url)
    parsed_page = Nokogiri::HTML(page)

    self.name = parsed_page.css('h1.heading-xlarge').text
    self.description = parsed_page.css('.column-desktop-two-thirds').first.css('p').text

    self.skills.clear
    parsed_page.css('#Skills ul li').each do |li|
      self.skills << Skill.find_or_create_by(name: li.text.strip)
    end
    save
  end
end
