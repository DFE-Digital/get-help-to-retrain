namespace :data_import do

  # bin/rails data_import:scrape_job_profiles
  task scrape_job_profiles: :environment do

    print 'Scraping job profiles from National Careers Service site'
    if JobProfile.any?
      JobProfile.all.each do |job_profile|
        print "Scraping job profile #{job_profile.slug}"
        job_profile.scrape
        sleep(0.1)
      end
    else
      print 'No job profiles setup - please import sitemap first'
    end
  end
end
