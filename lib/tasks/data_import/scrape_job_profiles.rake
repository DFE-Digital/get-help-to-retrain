require 'HTTParty'
require 'Nokogiri'

namespace :data_import do

  # bin/rails data_import:scrape_job_profiles
  task scrape_job_profiles: :environment do

    p 'Scraping job profiles from National Careers Service site'
    if JobProfile.any?
      #TODO: process `all` job profiles when we figure out which data is of interest
      JobProfile.limit(10).each do |job_profile|
        p "Scraping job profile #{job_profile.slug}"
        job_profile.scrape
        sleep(0.1)
      end
    else
      p 'No job profiles setup - please import sitemap first'
    end
  end
end
