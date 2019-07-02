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

  describe 'related profiles' do
    it 'parses the right slugs' do
      expect(scraped['related_profiles']).to contain_exactly(
        'local-government-administrative-assistant',
        'data-entry-clerk',
        'hotel-receptionist',
        'personal-assistant',
        'health-records-clerk'
      )
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

  describe 'alternative_titles' do
    let(:fake_page) { Mechanize::Page.new nil, nil, body, 200, scraper.mechanize }

    around do |example|
      scraper.metadata.page fake_page
      example.run
      scraper.metadata.page nil
    end

    context 'with available alternative titles' do
      let(:body) do
        '<div class="column-desktop-two-thirds">
          <h1 class="heading-xlarge"> Admin assistant</h1>
          <h2 class="heading-secondary"><span class="sr-hidden">Alternative titles for this job include </span>Office administrator, clerical assistant, administrative assistant</h2>
          <p>Admin assistants give support to offices by organising meetings, typing documents and updating computer records.</p>
        </div>'
      end

      it 'parses alternative titles' do
        expect(scraped['alternative_titles']).to contain_exactly('Office administrator', 'clerical assistant', 'administrative assistant')
      end
    end

    context 'with single alternative title' do
      let(:body) do
        '<div class="column-desktop-two-thirds">
          <h1 class="heading-xlarge"> Admin assistant</h1>
          <h2 class="heading-secondary"><span class="sr-hidden">Alternative titles for this job include </span>Office administrator</h2>
          <p>Admin assistants give support to offices by organising meetings, typing documents and updating computer records.</p>
        </div>'
      end

      it 'parses alternative titles' do
        expect(scraped['alternative_titles']).to contain_exactly('Office administrator')
      end
    end

    context 'with no alternative titles' do
      let(:body) do
        '<div class="column-desktop-two-thirds">
          <h1 class="heading-xlarge"> Admin assistant</h1>
          <p>Admin assistants give support to offices by organising meetings, typing documents and updating computer records.</p>
        </div>'
      end

      it 'returns empty array' do
        expect(scraped['alternative_titles']).to be_empty
      end
    end
  end
end
