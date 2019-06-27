require 'rails_helper'

RSpec.describe JobProfileScraper, vcr: { cassette_name: 'explore_my_careers_job_profile' } do
  let(:scraper) { described_class.new }
  let(:job_profile_url) { 'https://nationalcareers.service.gov.uk/job-profiles/admin-assistant' }
  let(:skills) do
    [
      'administration skills',
      'customer service skills'
    ]
  end

  describe '#scrape' do
    subject(:scraped) { scraper.scrape(job_profile_url) }

    it 'parses job profile name' do
      expect(scraped['title']).to eq 'Admin assistant'
    end

    it 'parses job profile description' do
      expect(scraped['description']).to match 'organising meetings'
    end

    it 'parses job profile minimum salary' do
      expect(scraped['salary_min']).to eq 14_000
    end

    it 'parses job profile maximum salary' do
      expect(scraped['salary_max']).to eq 30_000
    end

    it 'parses job profile full page' do
      expect(scraped['content']).to match 'National Careers Service'
    end

    it 'parses skills' do
      expect(scraped['skills']).to include(*skills)
    end
  end
end
