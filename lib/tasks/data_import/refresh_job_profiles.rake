namespace :data_import do
  # bin/rails data_import:scrape_job_profiles
  task refresh_job_profiles: :environment do
    print 'Refreshing job profile attributes with previously scraped content'
    if JobProfile.any?
      JobProfile.all.each do |job_profile|
        scraper = JobProfileScraper.new
        cached_page = Mechanize::Page.new(nil, nil, job_profile.content, 200, scraper.mechanize)
        scraper.metadata.page cached_page
        print "Refreshing job profile #{job_profile.slug}"
        job_profile.scrape(scraper)
      end
    else
      print 'No job profiles setup - please import sitemap first'
    end
  end
end
