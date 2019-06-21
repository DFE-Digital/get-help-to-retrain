require 'rails_helper'

RSpec.describe SitemapScraper, :vcr_all do
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
    subject { scraper.scrape }

    it 'returns an array of urls' do
      expect(subject).to have_key 'urls'
      expect(subject['urls']).to be_an(Array)
    end
  end

  describe

  describe '#categories' do
    subject { scraper.categories }

    before(:each) { scraper.scrape }

    it 'includes only category urls and slugs' do
      expect(subject).to include(categories)
    end

    it 'excludes other urls' do
      expect(subject).to_not include(job_profiles)
    end
  end

  describe '#job_profiles' do
    subject { scraper.job_profiles }

    before(:each) { scraper.scrape }

    it 'includes only job profile urls and slugs' do
      expect(subject).to include job_profiles
    end

    it 'excludes other urls' do
      expect(subject).to_not include categories
    end
  end
end
