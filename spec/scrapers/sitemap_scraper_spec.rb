require 'rails_helper'

RSpec.describe SitemapScraper, vcr: { cassette_name: 'explore_my_careers_sitemap' } do
  let(:scraper) { described_class.new }

  let(:categories) do
    {
      'administration' => 'https://nationalcareers.service.gov.uk/job-categories/administration',
      'business-and-finance' => 'https://nationalcareers.service.gov.uk/job-categories/business-and-finance'
    }
  end

  let(:job_profiles) do
    {
      'admin-assistant' => 'https://nationalcareers.service.gov.uk/job-profiles/admin-assistant',
      'finance-officer' => 'https://nationalcareers.service.gov.uk/job-profiles/finance-officer'
    }
  end

  describe '#scrape' do
    subject(:scraped) { scraper.scrape }

    it 'returns an array of urls' do
      expect(scraped['urls']).to be_an(Array)
    end
  end

  describe '#categories' do
    subject(:scraped_categories) { scraper.categories }

    before { scraper.scrape }

    it 'includes only category urls and slugs' do
      expect(scraped_categories).to include(categories)
    end

    it 'excludes other urls' do
      expect(scraped_categories).not_to include(job_profiles)
    end
  end

  describe '#job_profiles' do
    subject(:scraped_job_profiles) { scraper.job_profiles }

    before { scraper.scrape }

    it 'includes only job profile urls and slugs' do
      expect(scraped_job_profiles).to include job_profiles
    end

    it 'excludes other urls' do
      expect(scraped_job_profiles).not_to include categories
    end
  end
end
