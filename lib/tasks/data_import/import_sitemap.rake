namespace :data_import do
  # bin/rails data_import:import_sitemap
  task import_sitemap: :environment do
    print 'Importing sitemap from National Careers Service site'
    sitemap = SitemapScraper.new
    sitemap.scrape

    sitemap.categories.each do |slug, url|
      print "Found category page #{url}"
      Category.import(slug, url)
    end

    sitemap.job_profiles.each do |slug, url|
      print "Found job profile page #{url}"
      JobProfile.import(slug, url)
    end
  end
end
