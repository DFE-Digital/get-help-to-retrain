require 'rails_helper'
require 'support/tasks'

RSpec.describe 'data_import:scrape_categories', vcr: { cassette_name: 'explore_my_careers_category' } do
  let(:slug) { 'administration' }
  let(:url) { 'https://nationalcareers.service.gov.uk/job-categories/administration' }
  let!(:category) { create :category, slug: slug, source_url: url }
  let!(:admin_assistant) { create :job_profile, slug: 'admin-assistant' }
  let!(:bookkeeper) { create :job_profile, slug: 'bookkeeper' }

  it 'updates category names' do
    task.execute
    expect(category.reload.name).to eq 'Administration'
  end

  it 'links categories to job profiles' do
    task.execute
    expect(category.job_profiles).to include admin_assistant
    expect(category.job_profiles).to include bookkeeper
  end
end
