require 'rails_helper'
require 'support/tasks'

RSpec.describe 'rake data_import:import_sitemap' do
  let!(:fake_scraper) { SitemapScraper.new }

  before do
    expect(SitemapScraper).to receive(:new) { fake_scraper }
    expect(fake_scraper).to receive(:scrape)
  end

  it 'creates categories' do
    expect(fake_scraper).to receive(:categories) do
      {
        'administration' => 'https://nationalcareers.service.gov.uk/job-categories/administration',
        'business-and-finance' => 'https://nationalcareers.service.gov.uk/job-categories/business-and-finance'
      }
    end
    expect(fake_scraper).to receive(:job_profiles) do
      {}
    end

    expect { task.execute }.to change { Category.count }.by(2)
  end

  it 'creates jobs' do
    expect(fake_scraper).to receive(:categories) do
      {}
    end
    expect(fake_scraper).to receive(:job_profiles) do
      {
        'admin-assistant' => 'https://nationalcareers.service.gov.uk/job-profiles/admin-assistant',
        'finance-officer' => 'https://nationalcareers.service.gov.uk/job-profiles/finance-officer'
      }
    end

    expect { task.execute }.to change { JobProfile.count }.by(2)
  end
end
