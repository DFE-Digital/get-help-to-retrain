class CategoryScraper
  include Wombat::Crawler

  category_name css: 'h1.heading-xlarge'

  links "xpath=//li[@class='job-categories_item']/h2/a/@href", :list

  def parse(metadata, url=nil)
    @parsed ||= super(metadata, url)
  end

  def job_profile_slugs
    @parsed['links'].map { |href| href.match(/job-profiles\/(.*)$/)[1] }
  end
end
