require 'rails_helper'
require 'support/tasks'

RSpec.describe 'rake data_import:import_sitemap' do
  let!(:fake_scraper) { SitemapScraper.new }

  before do
    allow(SitemapScraper).to receive(:new) { fake_scraper }
    allow(fake_scraper).to receive(:scrape)
  end

  it 'creates categories' do
    allow(fake_scraper).to receive(:categories).and_return(
      'administration' => 'https://nationalcareers.service.gov.uk/job-categories/administration',
      'business-and-finance' => 'https://nationalcareers.service.gov.uk/job-categories/business-and-finance'
    )
    allow(fake_scraper).to receive(:job_profiles).and_return({})

    expect { task.execute }.to change(Category, :count).by(2)
  end

  it 'creates jobs' do
    allow(fake_scraper).to receive(:categories).and_return({})
    allow(fake_scraper).to receive(:job_profiles).and_return(
      'admin-assistant' => 'https://nationalcareers.service.gov.uk/job-profiles/admin-assistant',
      'finance-officer' => 'https://nationalcareers.service.gov.uk/job-profiles/finance-officer'
    )

    expect { task.execute }.to change(JobProfile, :count).by(2)
  end
end
