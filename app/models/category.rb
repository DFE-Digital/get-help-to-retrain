class Category < ApplicationRecord
  has_and_belongs_to_many :job_profiles

  def self.import(url)
    slug = url.match(/job-categories\/(.*)$/)[1]
    find_or_create_by(slug: slug) do |category|
      category.update(source_url: url, name: slug.titleize)
    end
  end

  def scrape
    page = HTTParty.get(source_url)
    parsed_page = Nokogiri::HTML(page)

    self.name = parsed_page.css('h1.heading-xlarge').text
    self.job_profiles.clear
    parsed_page.css('li.job-categories_item h2 a').each do |link|
      slug = link['href'].match(/job-profiles\/(.*)$/)[1]
      job_profile = JobProfile.find_by_slug(slug)
      self.job_profiles << job_profile if job_profile
    end
    save
  end
end
