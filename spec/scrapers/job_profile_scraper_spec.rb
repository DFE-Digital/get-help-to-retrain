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
    subject { scraper.scrape(job_profile_url) }

    it 'parses job profile name' do
      expect(subject['title']).to eq 'Admin assistant'
    end

    it 'parses job profile description' do
      expect(subject['description']).to match 'organising meetings'
    end

    it 'parses job profile full page' do
      expect(subject['body']).to match 'National Careers Service'
    end

    it 'parses skills' do
      expect(subject['skills']).to be_an(Array)
      expect(subject['skills']).to include *skills
    end
  end
end
