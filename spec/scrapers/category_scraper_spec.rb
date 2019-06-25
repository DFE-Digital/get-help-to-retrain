require 'rails_helper'

RSpec.describe CategoryScraper, vcr: { cassette_name: 'explore_my_careers_category' } do
  let(:scraper) { described_class.new }
  let(:category_url) { 'https://nationalcareers.service.gov.uk/job-categories/administration' }
  let(:job_profiles) { %w[admin-assistant bookkeeper] }

  describe '#scrape' do
    subject(:scraped) { scraper.scrape(category_url) }

    it 'parses category name' do
      expect(scraped['title']).to eq 'Administration'
    end
  end

  describe '#job_profile_slugs' do
    subject(:slugs) { scraper.job_profile_slugs }

    before { scraper.scrape(category_url) }

    it 'includes only job profile slugs' do
      expect(slugs).to include(*job_profiles)
    end
  end
end
