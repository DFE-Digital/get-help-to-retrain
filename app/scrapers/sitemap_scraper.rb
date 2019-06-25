class SitemapScraper
  include Wombat::Crawler

  base_url 'https://nationalcareers.service.gov.uk'
  path '/sitemap/sitemap.xml'
  document_format :xml

  urls 'css=loc', :list

  def parse(metadata, url = nil)
    @parse ||= super(metadata, url)
  end

  def categories
    category_urls = @parse['urls'].select { |url| url =~ /job-categories/ }
    category_urls.reduce({}) do |hash, url|
      slug = url.match(%r{job-categories/(.*)$})[1]
      hash.merge(slug => url)
    end
  end

  def job_profiles
    job_profile_urls = @parse['urls'].select { |url| url =~ /job-profiles/ }
    job_profile_urls.reduce({}) do |hash, url|
      slug = url.match(%r{job-profiles/(.*)$})[1]
      hash.merge(slug => url)
    end
  end
end
