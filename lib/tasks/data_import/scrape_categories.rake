namespace :data_import do
  # bin/rails data_import:scrape_categories
  task scrape_categories: :environment do
    print 'Scraping categories from National Careers Service site'
    if Category.any?
      Category.all.each do |category|
        print "Scraping category #{category.slug}"
        category.scrape
        sleep(0.1)
      end
    else
      print 'No categories setup - please import sitemap first'
    end
  end
end
