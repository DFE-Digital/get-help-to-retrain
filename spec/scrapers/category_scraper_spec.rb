require 'rails_helper'

RSpec.describe CategoryScraper, vcr: { cassette_name: 'explore_my_careers_category' } do
  let(:scraper) { described_class.new }
  let(:category_url) { 'https://nationalcareers.service.gov.uk/job-categories/administration' }
  let(:job_profiles) { %w(admin-assistant bookkeeper) }

  describe '#scrape' do
    subject { scraper.scrape(category_url) }

    it 'parses category name' do
      expect(subject['title']).to eq 'Administration'
    end
  end

  describe '#job_profile_slugs' do
    subject { scraper.job_profile_slugs }

    before(:each) { scraper.scrape(category_url) }

    it 'includes only job profile slugs' do
      expect(subject).to be_an(Array)
      expect(subject).to include(*job_profiles)
    end
  end
end
