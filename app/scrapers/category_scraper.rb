class CategoryScraper
  include Wombat::Crawler

  title css: 'h1.heading-xlarge'
  links "xpath=//li[@class='job-categories_item']/h2/a/@href", :list

  def parse(metadata, url = nil)
    @parse ||= super(metadata, url)
  end

  def job_profile_slugs
    @parse['links'].map { |href| href.match(%r{job-profiles/(.*)$})[1] }
  end
end
