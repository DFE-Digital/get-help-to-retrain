require 'HTTParty'
require 'Nokogiri'

namespace :data_import do

  # bin/rails data_import:import_sitemap
  task import_sitemap: :environment do

    p 'Importing sitemap from National Careers Service site'
    sitemap = HTTParty.get('https://nationalcareers.service.gov.uk/sitemap/sitemap.xml')

    parsed_map = Nokogiri::XML(sitemap)
    parsed_map.css('loc').each do |node|
      url = node.text
      if url =~ /job-categories/
        p "Found category page #{url}"
        Category.import(url)
      elsif url =~ /job-profiles/
        p "Found job profile page #{url}"
        JobProfile.import(url)
      end
    end
  end
end
