require 'rails_helper'

RSpec.describe JobProfileScraper, vcr: { cassette_name: 'explore_my_careers_job_profile' } do
  subject(:scraped) { scraper.scrape(job_profile_url) }

  let(:scraper) { described_class.new }
  let(:job_profile_url) { 'https://nationalcareers.service.gov.uk/job-profiles/admin-assistant' }

  describe 'title' do
    it 'parses job profile name' do
      expect(scraped['title']).to eq 'Admin assistant'
    end
  end

  describe 'description' do
    it 'parses job profile description' do
      expect(scraped['description']).to match 'organising meetings'
    end
  end

  describe 'content' do
    it 'parses job profile full page' do
      expect(scraped['content']).to match 'National Careers Service'
    end
  end

  describe 'skills' do
    it 'parses skills' do
      expect(scraped['skills']).to include('administration skills', 'customer service skills')
    end
  end

  describe 'salary_max' do
    it 'parses job profile maximum salary' do
      expect(scraped['salary_max']).to eq 30_000
    end
  end

  describe 'salary_min' do
    let(:fake_page) { Mechanize::Page.new nil, nil, body, 200, scraper.mechanize }

    around do |example|
      scraper.metadata.page fake_page
      example.run
      scraper.metadata.page nil
    end

    context 'with valid salary' do
      let(:body) do
        '<div id="Salary" class="column-40 job-profile-heroblock">
          <div class="job-profile-salary job-profile-heroblock-content">
            <p class="dfc-code-jpsstarter">£18,000 <span>Starter</span></p>
          </div>
        </div>'
      end

      it 'parses job profile minimum salary' do
        expect(scraped['salary_min']).to eq 18_000
      end
    end

    context 'with missing salary' do
      let(:body) do
        '<div id="Salary" class="column-40 job-profile-heroblock">
        </div>'
      end

      it 'returns nil' do
        expect(scraped['salary_min']).to be_nil
      end
    end

    context 'with invalid salary' do
      let(:body) do
        '<div id="Salary" class="column-40 job-profile-heroblock">
          <div class="job-profile-salary job-profile-heroblock-content">
            <p class="dfc-code-jpsstarter">£LOADSAMONEY <span>Starter</span></p>
          </div>
        </div>'
      end

      it 'returns nil' do
        expect(scraped['salary_min']).to be_nil
      end
    end
  end
end
